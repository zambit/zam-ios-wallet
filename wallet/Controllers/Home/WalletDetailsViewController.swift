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

enum WalletDetailsCellType: Equatable {
    case brief
    case chart
    case switcher
    case information
    case transaction
}

protocol WalletDetailsViewData {

    var type: WalletDetailsCellType { get }
}

class WalletDetailsViewController: FlowViewController, WalletNavigable {

    var onSendFromWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onExit: (() -> Void)?

    weak var sendDelegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var priceAPI: PriceAPI?
    var historyAPI: HistoryAPI?

    @IBOutlet private var tableView: UITableView!

    private var exitButton: HighlightableButton?

    private var phone: String?
    private var wallets: [Wallet]?
    private var walletsChartsPoints: [ChartLayer.Coordinate]?
    private var currentIndex: Int?
    private var coinPrice: CoinPrice?
    private var currentInterval: CoinPriceChartIntervalType = .day

    private var viewData: [[WalletDetailsViewData]] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hero.isEnabled = true

        setupDefaultStyle()

        tableView.hero.id = "floatingView"
        tableView.hero.modifiers = [.useScaleBasedSizeChange]
        tableView.backgroundColor = .white
        tableView.cornerRadius = 16.0
        tableView.maskToBounds = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        tableView.register(WalletDetailsBriefTableViewCell.self, forCellReuseIdentifier: "WalletDetailsBriefTableViewCell")
        tableView.register(WalletDetailsChartTableViewCell.self, forCellReuseIdentifier: "WalletDetailsChartTableViewCell")
        tableView.register(WalletDetailsListsTableViewCell.self, forCellReuseIdentifier: "WalletDetailsListsTableViewCell")

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

        updateTableView()
    }

    func loadData() {
        let group = DispatchGroup()

        group.enter()
        loadPrices(completion: {
            [weak self]
            coinData in

            self?.coinPrice = coinData
            group.leave()
        })

        group.enter()
        loadChartsPoints(for: currentInterval, completion: {
            [weak self]
            points in

            self?.walletsChartsPoints = points
            group.leave()
        })

        group.notify(queue: .main, execute: {
            [weak self] in

            self?.updateTableView()
        })
    }

    private func loadPrices(completion: @escaping (CoinPrice) -> Void) {
        guard let currentIndex = currentIndex, let wallets = wallets, wallets.count > currentIndex else {
            return
        }

        let wallet = wallets[currentIndex]

        priceAPI?.cancelAllTasks()
        priceAPI?.getCoinDetailPrice(coin: wallet.coin).done {
            coinData in
            completion(coinData)
        }.catch {
            error in
            Crashlytics.sharedInstance().recordError(error)
        }
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
            aggregate = 10
            limit = 120
        }

        historyAPI.cancellAllTasks()
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

    private var updatedViewData: [[WalletDetailsViewData]] {
        var viewData: [[WalletDetailsViewData]] = []
        var coinSection: [WalletDetailsViewData] = []

        if let currentIndex = currentIndex,
            let wallets = wallets,
            let phone = phone {

            let walletsItems = wallets.compactMap {
                return WalletItemData(data: $0, phoneNumber: phone)
            }

            let price = coinPrice?.description(property: .price)
            let change = coinPrice?.description(property: .change24h)
            let changePct = coinPrice?.description(property: .changePct24h)
            let isChangePositive = coinPrice != nil ? coinPrice!.change24h >= 0 : nil


            let briefData = WalletDetailsBriefViewData(currentIndex: currentIndex,
                                                       wallets: walletsItems,
                                                       price: price,
                                                       change: change,
                                                       changePct: changePct,
                                                       isChangePositive: isChangePositive)
            coinSection.append(briefData)
        }


        let chartData = WalletDetailsChartViewData(points: walletsChartsPoints, currentInterval: currentInterval)
        coinSection.append(chartData)

        viewData.append(coinSection)

        return viewData
    }

    private func updateTableView() {
        var indexPathsToUpdate: [IndexPath] = []
        let updatedViewData = self.updatedViewData

        guard updatedViewData.count == viewData.count else {
            self.viewData = updatedViewData
            tableView?.reloadData()
            return
        }

        for (i, section) in self.viewData.enumerated() {
            for (j, data) in section.enumerated() {
                if data.type == updatedViewData[i][j].type {
                    switch data.type {
                    case .brief:
                        guard
                            let old = data as? WalletDetailsBriefViewData,
                            let new = updatedViewData[i][j] as? WalletDetailsBriefViewData else {
                                break
                        }

                        if old != new {
                            let indexPath = IndexPath(row: j, section: i)
                            indexPathsToUpdate.append(indexPath)
                        }
                    case .chart:
                        guard
                            let old = data as? WalletDetailsChartViewData,
                            let new = updatedViewData[i][j] as? WalletDetailsChartViewData else {
                                break
                        }

                        if old != new {
                            let indexPath = IndexPath(row: j, section: i)
                            indexPathsToUpdate.append(indexPath)
                        }
                    default:
                        break
                    }
                }
            }
        }

        self.viewData = updatedViewData
        tableView?.reloadRows(at: indexPathsToUpdate, with: .none)
    }

    private func updateViewData() {
        self.viewData = updatedViewData
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

// MARK: - Extensions

extension WalletDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewData[indexPath.section][indexPath.row]

        switch data.type {
        case .brief:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "WalletDetailsBriefTableViewCell", for: indexPath)

            guard let cell = _cell as? WalletDetailsBriefTableViewCell else {
                fatalError()
            }

            guard let viewData = data as? WalletDetailsBriefViewData else {
                fatalError()
            }

            cell.delegate = self
            cell.configure(with: viewData)

            return cell
        case .chart:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "WalletDetailsChartTableViewCell", for: indexPath)

            guard let cell = _cell as? WalletDetailsChartTableViewCell else {
                fatalError()
            }

            guard let viewData = data as? WalletDetailsChartViewData else {
                fatalError()
            }

            cell.delegate = self
            cell.configure(with: viewData)

            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension WalletDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = viewData[indexPath.section][indexPath.row]

        switch data.type {
        case .brief:
            return 200.0
        case .chart:
            return 250.0
        default:
            return 0.0
        }
    }
}

extension WalletDetailsViewController: WalletDetailsBriefDelegate {

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

        self.walletsChartsPoints = nil
        self.coinPrice = nil
        self.updateTableView()

        loadData()
    }
}

extension WalletDetailsViewController: WalletDetailsChartDelegate {

    func walletDetailsChartIntervalSelected(_ walletDetailsChart: WalletDetailsChartTableViewCell, interval: CoinPriceChartIntervalType) {
        self.currentInterval = interval

        self.walletsChartsPoints = nil
        self.updateTableView()

        loadChartsPoints(for: interval, completion: {
            [weak self]
            points in

            self?.walletsChartsPoints = points
            self?.updateTableView()
        })
    }
}

extension WalletDetailsViewController: SendMoneyViewControllerDelegate {

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        sendDelegate?.sendMoneyViewControllerSendingProceedWithSuccess(sendMoneyViewController)
    }

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController, updated data: Wallet, index: Int) {
        wallets?[index] = data
        updateTableView()
    }
}

extension WalletDetailsViewController: AdvancedTransitionDelegate {

    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String : Any]) {
        guard let index = params["walletIndex"] as? Int else {
            return
        }
        currentIndex = index

        updateTableView()
    }
}
