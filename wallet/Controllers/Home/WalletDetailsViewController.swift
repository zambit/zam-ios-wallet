//
//  WalletDetailsViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class WalletDetailsViewController: FlowViewController, WalletNavigable, AdvancedTransitionDelegate, SendMoneyViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, WalletDetailsBriefDelegate, WalletDetailsChartDelegate {

    var onSendFromWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onExit: (() -> Void)?

    weak var sendDelegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var priceAPI: PriceAPI?
    var historyAPI: HistoryAPI?

    class CellsBalancer {

        unowned var parent: WalletDetailsViewController

        private(set) weak var briefCell: WalletDetailsBriefTableViewCell?
        private(set) weak var chartCell: WalletDetailsChartTableViewCell?

        init(parent: WalletDetailsViewController) {
            self.parent = parent
        }

        func registerCellsInTableView(_ tableView: UITableView) {
            tableView.register(WalletDetailsBriefTableViewCell.self, forCellReuseIdentifier: "WalletDetailsBriefTableViewCell")
            tableView.register(WalletDetailsChartTableViewCell.self, forCellReuseIdentifier: "WalletDetailsChartTableViewCell")
        }

        func getNumbersOfSections() -> Int {
            return 1
        }

        func getNumberOfRowsInSection(_ section: Int) -> Int {
            switch section {
            case 0:
                return 2
            default:
                return 0
            }
        }

        func getConfiguredCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell? {
            switch indexPath {
            case IndexPath(row: 0, section: 0):
                let _cell = parent.tableView?.dequeueReusableCell(withIdentifier: "WalletDetailsBriefTableViewCell", for: indexPath)

                guard let cell = _cell as? WalletDetailsBriefTableViewCell else {
                    return nil
                }

                briefCell = cell

                guard
                    let currentIndex = parent.currentIndex,
                    let wallets = parent.wallets,
                    let phone = parent.phone else {
                    return cell
                }

                let cards = wallets.compactMap {
                    return WalletItemData(data: $0, phoneNumber: phone)
                }

                cell.delegate = parent
                cell.configure(currentIndex: currentIndex, wallets: cards)

                return cell
            case IndexPath(row: 1, section: 0):
                let _cell = parent.tableView?.dequeueReusableCell(withIdentifier: "WalletDetailsChartTableViewCell", for: indexPath)

                guard let cell = _cell as? WalletDetailsChartTableViewCell else {
                    return nil
                }

                chartCell = cell

                cell.delegate = parent
                cell.beginChartLoading()

                return cell
            default:
                return nil
            }
        }

        func getHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat? {
            switch indexPath {
            case IndexPath(row: 0, section: 0):
                return 200.0
            case IndexPath(row: 1, section: 0):
                return 250.0
            default:
                return nil
            }
        }

        func reloadBrief() {
            parent.tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }

    @IBOutlet private var tableView: UITableView!

    private var exitButton: HighlightableButton?

    private var phone: String?
    private var wallets: [Wallet]?
    private var currentIndex: Int?

    private var currentInterval: CoinPriceChartIntervalType = .day

    private lazy var balancer = CellsBalancer(parent: self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hero.isEnabled = true

        setupDefaultStyle()

        tableView.hero.id = "floatingView"
        tableView.backgroundColor = .white
        tableView.cornerRadius = 16.0
        tableView.maskToBounds = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        balancer.registerCellsInTableView(tableView)

        let exitButton = HighlightableButton(type: .custom)
        exitButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        exitButton.setImage(#imageLiteral(resourceName: "icExit"), for: .normal)
        exitButton.setHighlightedTintColor(.darkIndigo)

        view.addSubview(exitButton)

        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15.0).isActive = true
        exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exitButton.addTarget(self, action: #selector(exitButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.exitButton = exitButton

        loadData()
    }

    func prepare(wallets: [Wallet], currentIndex: Int, phone: String) {
        self.wallets = wallets
        self.currentIndex = currentIndex
        self.phone = phone
    }

    func loadData() {
        guard let currentIndex = currentIndex, let wallets = wallets, wallets.count > currentIndex else {
            return
        }

        let wallet = wallets[currentIndex]

        priceAPI?.getCoinPrice(coin: wallet.coin).done {
            [weak self]
            coinData in

            self?.balancer.briefCell?.update(price: coinData.description(property: .price), change: coinData.description(property: .change24h), changePct: coinData.description(property: .changePct24h), isChangePositive: coinData.change24h >= 0)
        }.catch {
            error in

            print(error)
        }

        balancer.chartCell?.beginChartLoading()
        loadChartsPoints(for: currentInterval, completion: {
            [weak self]
            points in

            self?.balancer.chartCell?.endChartLoading()
            self?.balancer.chartCell?.setupChart(points: points)
        })
    }

    private func loadChartsPoints(for interval: CoinPriceChartIntervalType, completion: @escaping ([ChartLayer.Coordinate]) -> Void) {
        guard let currentIndex = currentIndex, let wallets = wallets, let historyAPI = historyAPI, wallets.count > currentIndex else {
            return
        }

        var type: HistoryAPI.HistoricalInterval
        var aggregate: Int
        var limit: Int

        switch interval {
        case .day:
            type = .minute
            aggregate = 30
            limit = 48
        case .week:
            type = .hour
            aggregate = 3
            limit = 56
        case .month:
            type = .hour
            aggregate = 12
            limit = 60
        case .threeMonth:
            type = .day
            aggregate = 2
            limit = 45
        case .year:
            type = .day
            aggregate = 7
            limit = 52
        case .all:
            type = .day
            aggregate = 30
            limit = 40
        }

        historyAPI.getHistoricalPrice(for: wallets[currentIndex].coin, convertingTo: .standard, interval: type, groupingBy: aggregate, count: limit).done {
            prices in

            let coordinates = prices.map {
                return ChartLayer.Coordinate(x: $0.time.unixTimestamp,
                                             y: $0.closePrice.doubleValue,
                                             text: $0.description(property: .closePrice),
                                             additional: interval == .day ?
                                                    Date(unixTimestamp: $0.time.unixTimestamp).fullTimeFormatted : Date(unixTimestamp: $0.time.unixTimestamp).fullFormatted
                )
            }
            performWithDelay {
                completion(coordinates)
            }
        }.catch {
            error in

            Crashlytics.sharedInstance().recordError(error)
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return balancer.getNumbersOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balancer.getNumberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return balancer.getConfiguredCellForIndexPath(indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return balancer.getHeightForRowAtIndexPath(indexPath) ?? 0.0
    }

    // MARK: - WalletDetailsBriefDelegate

    func walletDetailsBriefSendButtonTapped(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, walletIndex: Int) {
        guard let wallets = wallets, let phone = phone else {
            return
        }

        onSendFromWallet?(walletIndex, wallets, phone)
    }

    func walletDetailsBriefDepositButtonTapped(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, walletIndex: Int) {
        guard let wallets = wallets, let phone = phone else {
            return
        }

        onDepositToWallet?(walletIndex, wallets, phone)
    }

    func walletDetailsBriefCurrentWalletChanged(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, to index: Int) {
        self.currentIndex = index

        loadData()
    }

    func walletDetailsChartIntervalSelected(_ walletDetailsChart: WalletDetailsChartTableViewCell, interval: CoinPriceChartIntervalType) {

        self.currentInterval = interval

        walletDetailsChart.beginChartLoading()
        loadChartsPoints(for: interval, completion: {
            walletDetailsChart.endChartLoading()
            walletDetailsChart.setupChart(points: $0)
        })
    }

    // MARK: - AdvancedTransitionDelegate

    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String : Any]) {
        guard let index = params["walletIndex"] as? Int else {
            return
        }

        currentIndex = index
        balancer.briefCell?.update(currentIndex: index)
    }

    // MARK: - SendMoneyViewControllerDelegate

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        sendDelegate?.sendMoneyViewControllerSendingProceedWithSuccess(sendMoneyViewController)
    }

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController, updated data: Wallet, index: Int) {
        wallets?[index] = data

        balancer.reloadBrief()
    }

    // MARK: - Buttons events

    @objc
    private func exitButtonTouchUpInsideEvent(_ sender: Any) {
        if let index = currentIndex {
            advancedTransitionDelegate?.advancedTransitionWillBegin(from: self, params: ["walletIndex": index])
        }

        dismissKeyboard {
            [weak self] in
            self?.onExit?()
        }
    }
}
