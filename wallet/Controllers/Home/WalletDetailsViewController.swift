//
//  WalletDetailsViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Crashlytics

/**
 Wallet details screen.
 */
class WalletDetailsViewController: FlowViewController, WalletNavigable {

    var onSendFromWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onExit: (() -> Void)?

    weak var sendDelegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var userManager: UserDefaultsManager?
    var contactsManager: UserContactsManager?

    var userAPI: UserAPI?
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
    private var currentSwitcher: WalletDetailsSwitcherViewData.ChoiceType = .left

    private var paginator: Paginator<TransactionsGroup>?
    private var contactsData: [Contact] = []
    private var phoneNumberFormatter: PhoneNumberFormatter?
    private var filterData: TransactionsFilterProperties = TransactionsFilterProperties()

    /**
     Data source of the table view, containing all data for determine sections.
     */
    private var viewData: [(WalletDetailsHeaderViewData?, [WalletDetailsViewData])] = []


    // MARK: - FooterViews

    // Pagination loading footer view
    private lazy var loadingFooterView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        footerView.backgroundColor = UIColor.clear

        // Set up activity indicator
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = CGPoint(x: self.view.frame.width/2, y:22)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()

        footerView.addSubview(activityIndicatorView)

        return footerView
    }()

    // Initial loading footer view
    private lazy var refreshingFooterView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        footerView.backgroundColor = UIColor.clear

        // Set up activity indicator
        let activityIndicatorFrame = CGRect(x: footerView.width / 2 - 10.0, y: footerView.height / 2 - 10.0, width: 20.0, height: 20.0)
        let activityIndicator = SpinningAnimationLayer(frame: activityIndicatorFrame, color: .skyBlue)
        activityIndicator.animate()

        footerView.layer.addSublayer(activityIndicator)

        return footerView
    }()

    // Empty data footer view
    private lazy var placeholderFooterView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250.0))
        footerView.backgroundColor = UIColor.clear

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 102, height: 102))
        imageView.image = #imageLiteral(resourceName: "sadFace")
        imageView.center = CGPoint(x: footerView.width / 2, y: 50 + imageView.height / 2)

        footerView.addSubview(imageView)

        // Set up label
        let label = UILabel()
        label.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        label.textColor = .silver
        label.textAlignment = .center
        label.text = "Sorry, but you don’t have any history"
        label.sizeToFit()

        footerView.addSubview(label)

        label.center = CGPoint(x: footerView.width / 2, y: 50 + imageView.height + 25)

        return footerView
    }()


    // MARK: - UIViewController lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hero.isEnabled = true

        setupDefaultStyle()

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

        tableView.hero.id = "floatingView"
        tableView.hero.modifiers = [.useScaleBasedSizeChange]
        tableView.backgroundColor = .white
        tableView.cornerRadius = 16.0
        tableView.maskToBounds = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20.0, right: 0)

        tableView.register(WalletDetailsBriefTableViewCell.self,
                           forCellReuseIdentifier: "WalletDetailsBriefTableViewCell")
        tableView.register(WalletDetailsChartTableViewCell.self,
                           forCellReuseIdentifier: "WalletDetailsChartTableViewCell")
        tableView.register(WalletDetailsSwitcherTableViewCell.self,
                           forCellReuseIdentifier: "WalletDetailsSwitcherTableViewCell")
        tableView.register(WalletDetailsInformationTableViewCell.self,
                           forCellReuseIdentifier: "WalletDetailsInformationTableViewCell")
        tableView.register(TransactionCellComponent.self,
                           forCellReuseIdentifier: "TransactionCellComponent")
        tableView.register(TransactionsGroupHeaderComponent.self,
                           forHeaderFooterViewReuseIdentifier: "TransactionsGroupHeaderComponent")

        // Setup paginator
        self.paginator = Paginator<TransactionsGroup>(pageSize: 20, fetchHandler: {
            [weak self]
            (paginator: Paginator, pageSize: Int, nextPage: String?) in

            guard let strongSelf = self else {
                return
            }

            guard let token = strongSelf.userManager?.getToken() else {
                fatalError()
            }

            let filterData = strongSelf.filterData

            strongSelf.filterData.page = nextPage
            strongSelf.userAPI?.cancelTasks()
            strongSelf.userAPI?.getTransactions(token: token, filter: filterData, phoneNumberFormatter: strongSelf.phoneNumberFormatter, localContacts: strongSelf.contactsData).done {
                [weak self]
                page in

                // Check if current walletId is not what response for.
                guard let strongSelf = self, strongSelf.filterData.walletId == filterData.walletId else {
                    return
                }

                paginator.receivedResults(results: page.transactions, next: page.next ?? "")
            }.catch {
                error in
                Crashlytics.sharedInstance().recordError(error)
                paginator.failed()
            }

        }, resultsHandler: {
            [weak self]
            (paginator, results, new) in

            // Check for intersections
            if let last = results.last, let first = new.first, last.dateInterval == first.dateInterval {

                let sumAmount = try! last.amount.sum(with: first.amount)
                let transactions = last.transactions + first.transactions

                let concatiatedElement = TransactionsGroup(dateInterval: last.dateInterval, amount: sumAmount, transactions: transactions)

                let concatiatedResults = Array(results[0..<results.count - 1]) + [concatiatedElement] + Array(new[1..<new.count])

                // Update results
                paginator.results = concatiatedResults
            }

            self?.updateTableView()

            self?.updateTableViewFooter()
        }, refreshHandler: {
            [weak self]
            _, _ in

            self?.updateTableView()

            self?.updateTableViewFooter()
        }, resetHandler: {
            [weak self]
            _ in

            self?.updateTableView()

            self?.updateTableViewFooter()
        }, failureHandler: {
            [weak self]
            _ in

            self?.updateTableView()

            self?.updateTableViewFooter()
        })

        self.phoneNumberFormatter = PhoneNumberFormatter()

        if let contacts = contactsManager?.contacts {
            if contacts.count == 0 {
                contactsManager?.fetchContacts {
                    [weak self]
                    contacts in

                    self?.contactsData = contacts
                    self?.paginator?.fetchFirstPage()
                    self?.updateTableViewFooter()
                }
            } else {
                self.contactsData = contacts
                self.paginator?.fetchFirstPage()
                self.updateTableViewFooter()
            }
        }

        loadCoinData()
    }

    // MARK: - Public functions

    func prepare(wallets: [Wallet], currentIndex: Int, phone: String) {
        self.wallets = wallets
        self.currentIndex = currentIndex
        self.phone = phone
        self.filterData.walletId = wallets[currentIndex].id

        updateTableView()
    }

    // MARK: - Private functions

    private func loadCoinData() {
        let group = DispatchGroup()

        group.enter()
        loadCoinPrices(completion: {
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

    private func loadTransactions() {
        guard let wallets = wallets, let index = currentIndex, index < wallets.count else {
            return
        }

        self.filterData.walletId = wallets[index].id
        paginator?.fetchFirstPage()
    }

    private func loadCoinPrices(completion: @escaping (CoinPrice) -> Void) {
        guard let currentIndex = currentIndex, let wallets = wallets, wallets.count > currentIndex else {
            return
        }

        let wallet = wallets[currentIndex]

        priceAPI?.cancelAllTasks()
        priceAPI?.getCoinDetailPrice(coin: wallet.coin, convertingTo: .usd).done {
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

            performWithDelay {
                completion([])
            }
        }
    }

    // MARK: - Update

    /**
     Construct new viewData from current data properties.
     */
    private var updatedViewData: [(WalletDetailsHeaderViewData?, [WalletDetailsViewData])] {
        var viewData: [(WalletDetailsHeaderViewData?, [WalletDetailsViewData])] = []
        var coinSection: [WalletDetailsViewData] = []
        var transactionsSections: [(WalletDetailsHeaderViewData?, [WalletDetailsViewData])] = []

        // Create brief row
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

        // Create chart row
        let chartData = WalletDetailsChartViewData(points: walletsChartsPoints, currentInterval: currentInterval)
        coinSection.append(chartData)

        // Create swithcher row
        let switcherData = WalletDetailsSwitcherViewData(choiceLeft: "History", choiceRight: "Information", currentChoice: currentSwitcher)
        coinSection.append(switcherData)

        switch currentSwitcher {
        case .left:
            guard let paginator = self.paginator else {
                break
            }

            // Create transactions sections
            transactionsSections = paginator.results.map {
                group in

                let header = WalletDetailsTransactionHeaderViewData(date: DateInterval.walletString(from: group.dateInterval), amount: group.amount.description(property: .usd))

                let cells: [WalletDetailsTransactionViewData] = group.transactions.map {
                    transaction in

                    var recipient: String = transaction.participant

                    if let number = transaction.participantPhoneNumber {
                        recipient = number.formattedString
                    }

                    if let contact = transaction.contact {
                        recipient = contact.name
                    }

                    let cell = WalletDetailsTransactionViewData(image: transaction.coin.image,
                                                                status: transaction.status.formatted,
                                                                coinShort: transaction.coin.short,
                                                                recipient: recipient,
                                                                amount: transaction.amount.original.formatted ?? "",
                                                                fiatAmount: transaction.amount.description(property: .usd),
                                                                direction: transaction.direction)
                    return cell
                }

                return (header, cells)
            }

        case .right:
            guard let price = coinPrice else {
                break
            }

            // Create information rows
            let marketCap = price.description(property: .marketCap)
            let volume = price.description(property: .volume24h)
            let supply = price.description(property: .supply)

            let marketData = WalletDetailsInformationViewData(title: "Market Cap", detailValue: marketCap)
            let volumeData = WalletDetailsInformationViewData(title: "24H Volume", detailValue: volume)
            let supplyData = WalletDetailsInformationViewData(title: "Supply", detailValue: supply)

            coinSection.append(contentsOf: [marketData, volumeData, supplyData])
        }

        viewData.append((nil, coinSection))
        viewData.append(contentsOf: transactionsSections)
        return viewData
    }

    /**
     Update current viewData according current data properties and reload table view.
     */
    private func updateTableView() {
        DispatchQueue.main.async {
            self.viewData = self.updatedViewData
            self.tableView?.reloadData()
        }
    }

    /**
     Update table view footer according current paginator and switcher status.
     */
    private func updateTableViewFooter() {
        guard currentSwitcher == .left, let paginator = paginator else {
            self.tableView.tableFooterView = UIView()
            return
        }

        if paginator.requestStatus == .InProgress {
            self.tableView.tableFooterView = refreshingFooterView
            return
        }

        if paginator.reachedLastPage, !paginator.results.isEmpty {
            self.tableView.tableFooterView = UIView()
            return
        }

        if !paginator.reachedLastPage, !paginator.results.isEmpty {
            self.tableView.tableFooterView = loadingFooterView
            return
        }

        if paginator.reachedLastPage, paginator.results.isEmpty {
            self.tableView.tableFooterView = placeholderFooterView
            return
        }
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

/**
 Extension implements UITableViewDataSource protocol.
 */
extension WalletDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData[section].1.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let data = viewData[section].0 else {
            return nil
        }

        switch data.type {
        case .transaction:
            let _header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TransactionsGroupHeaderComponent")

            guard let header = _header as? TransactionsGroupHeaderComponent else {
                fatalError()
            }

            guard let viewData = data as? WalletDetailsTransactionHeaderViewData else {
                fatalError()
            }

            header.configure(with: viewData)

            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let data = viewData[section].0 else {
            return 0
        }

        switch data.type {
        case .transaction:
            return 46.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewData[indexPath.section].1[indexPath.row]

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
        case .switcher:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "WalletDetailsSwitcherTableViewCell", for: indexPath)

            guard let cell = _cell as? WalletDetailsSwitcherTableViewCell else {
                fatalError()
            }

            guard let viewData = data as? WalletDetailsSwitcherViewData else {
                fatalError()
            }

            cell.delegate = self
            cell.configure(with: viewData)

            return cell
        case .information:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "WalletDetailsInformationTableViewCell", for: indexPath)

            guard let cell = _cell as? WalletDetailsInformationTableViewCell else {
                fatalError()
            }

            guard let viewData = data as? WalletDetailsInformationViewData else {
                fatalError()
            }

            cell.configure(with: viewData)

            return cell
        case .transaction:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCellComponent", for: indexPath)

            guard let cell = _cell as? TransactionCellComponent else {
                fatalError()
            }

            guard let viewData = data as? WalletDetailsTransactionViewData else {
                fatalError()
            }

            cell.configure(with: viewData)
            return cell
        }
    }
}

/**
 Extension implements UITableViewDelegate protocol.
 */
extension WalletDetailsViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // when reaching bottom, load a new page
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom + scrollView.contentInset.top {

            // ask next page only if we haven't reached last page
            if let last = paginator?.reachedLastPage, last == false, currentSwitcher == .left {
                self.paginator?.fetchNextPage()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = viewData[indexPath.section].1[indexPath.row]

        switch data.type {
        case .brief:
            return 200.0
        case .chart:
            return 250.0
        case .switcher:
            return 50.0
        case .information:
            return 48.0
        case .transaction:
            return 74.0
        }
    }
}

/**
 Extension implements WalletDetailsBriefDelegate protocol. Provide callbacks from brief cell.
 */
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

        loadTransactions()
        loadCoinData()

        self.updateTableViewFooter()
    }
}

/**
 Extension implements WalletDetailsChartDelegate protocol. Provide callbacks from chart cell.
 */
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

/**
 Extension implements WalletDetailsSwitcherDelegate protocol. Provide callbacks from switcher cell.
 */
extension WalletDetailsViewController: WalletDetailsSwitcherDelegate {

    func walletDetailsSwitcher(_ walletDetailsSwitcher: WalletDetailsSwitcherTableViewCell, buttonSelected: WalletDetailsSwitcherViewData.ChoiceType) {
        self.currentSwitcher = buttonSelected

        updateTableViewFooter()
        updateTableView()

        if tableView.numberOfSections > 1 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .middle, animated: true)
        }
    }
}

/**
 Extension implements SendMoneyViewControllerDelegate protocol. It provides callbacks from SendMoneyViewController screen.
 */
extension WalletDetailsViewController: SendMoneyViewControllerDelegate {

    /**
     Notifies that sending transaction was done and balances needs to be reloaded.
     */
    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        sendDelegate?.sendMoneyViewControllerSendingProceedWithSuccess(sendMoneyViewController)
    }

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController, updated data: Wallet, index: Int) {
        wallets?[index] = data
        updateTableView()
    }
}

/**
 Extension implements AdvancedTransitionDelegate protocol. It provides transitions callbacks.
 */
extension WalletDetailsViewController: AdvancedTransitionDelegate {

    /**
     Ask viewController for preparing views to upcoming transition.
     */
    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String : Any]) {
        guard let index = params["walletIndex"] as? Int else {
            return
        }
        currentIndex = index
        updateTableView()
    }
}
