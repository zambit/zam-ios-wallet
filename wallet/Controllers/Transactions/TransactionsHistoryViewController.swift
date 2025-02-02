//
//  TransactionsHistoryViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Crashlytics

/**
 Transactions history screen providing pagination.
 */
class TransactionsHistoryViewController: FlowViewController, WalletNavigable, UISearchBarDelegate {

    var onFilter: ((TransactionsFilterProperties) -> Void)?

    var contactsManager: UserContactsManager?
    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var filterButton: UIButton?
    @IBOutlet var historyTableView: UITableView?

    private var paginator: Paginator<TransactionsGroup>?

    private var topRefreshControl: UIRefreshControl?
    private var bottomActivityIndicator: UIActivityIndicatorView?

    private var contactsData: [Contact] = []

    private var filterData: TransactionsFilterProperties = TransactionsFilterProperties()

    override func viewDidLoad() {
        super.viewDidLoad()

        isKeyboardHidesOnTap = true

        let filterBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filterButtonTouchUpInsideEvent(_:)))
        filterBarButtonItem.tintColor = nil
        navigationItem.setRightBarButton(filterBarButtonItem, animated: false)

        self.filterButton?.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
        self.filterButton?.addTarget(self, action: #selector(filterButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.historyTableView?.register(TransactionsGroupHeaderComponent.self, forHeaderFooterViewReuseIdentifier: "TransactionsGroupHeaderComponent")
        self.historyTableView?.register(TransactionCellComponent.self , forCellReuseIdentifier: "TransactionCellComponent")
        self.historyTableView?.allowsSelection = false
        self.historyTableView?.delegate = self
        self.historyTableView?.dataSource = self

        self.view.applyDefaultGradientHorizontally()

        topRefreshControl = UIRefreshControl()
        topRefreshControl?.addTarget(self, action: #selector(refreshControlValueChangedEvent(_:)), for: .valueChanged)
        topRefreshControl?.layer.zPosition = -2
        historyTableView?.refreshControl = topRefreshControl

        self.setupTableViewFooter()

        let formatter = PhoneNumberFormatter()

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

            strongSelf.filterData.page = nextPage
            strongSelf.userAPI?.cancelTasks()
            strongSelf.userAPI?.getTransactions(token: token, filter: strongSelf.filterData, phoneNumberFormatter: formatter, localContacts: strongSelf.contactsData).done {
                page in

                paginator.receivedResults(results: page.transactions, next: page.next ?? "")
            }.catch {
                error in

                Crashlytics.sharedInstance().recordError(error)

                paginator.failed()
            }

        }, resultsHandler: {
            [weak self]
            (paginator, old, new) in

            self?.topRefreshControl?.endRefreshing()

            // Pagination

            var indexPaths: [IndexPath] = []

            // Check for intersections
            if let last = old.last, let first = new.first, last.dateInterval == first.dateInterval {

                let sumAmount = try! last.amount.sum(with: first.amount)
                let transactions = last.transactions + first.transactions

                let concatiatedElement = TransactionsGroup(dateInterval: last.dateInterval, amount: sumAmount, transactions: transactions)

                let concatiatedResults = Array(old[0..<old.count - 1]) + [concatiatedElement] + Array(new[1..<new.count])

                // Update results
                paginator.results = concatiatedResults

                // Update header
                guard let header = self?.historyTableView?.headerView(forSection: old.count - 1) as? TransactionsGroupHeaderComponent else {
                    return
                }
                header.set(amount: concatiatedElement.amount.description(property: .usd) )

                // Add rows for concatiated section
                let section = old.count - 1
                var row = last.transactions.count
                for _ in first.transactions {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                    row += 1
                }
            }

            self?.historyTableView?.beginUpdates()
            self?.historyTableView?.insertRows(at: indexPaths, with: .fade)

            if old.count < paginator.results.count {
                let indexSet = IndexSet(integersIn: old.count..<paginator.results.count)
                self?.historyTableView?.insertSections(indexSet, with: .fade)
            }
            self?.historyTableView?.endUpdates()

            self?.updateTableViewFooter()
        }, refreshHandler: {
            [weak self]
            paginator, results in

            self?.topRefreshControl?.endRefreshing()

            if results.isEmpty {
                self?.setupPlaceholder()
            } else {
                self?.removePlaceholder()
            }

            self?.historyTableView?.reloadData()
            self?.updateTableViewFooter()
        }, failureHandler: {
            [weak self]
            paginator in

            performWithDelay {
                paginator.reset()
                self?.historyTableView?.reloadData()

                self?.setupPlaceholder()
                self?.topRefreshControl?.endRefreshing()
            }
        })

        if let contacts = contactsManager?.contacts {
            if contacts.count == 0 {
                contactsManager?.fetchContacts {
                    [weak self]
                    contacts in

                    self?.topRefreshControl?.beginRefreshing()
                    self?.contactsData = contacts
                    self?.paginator?.fetchFirstPage()
                }
            } else {
                self.topRefreshControl?.beginRefreshing()
                self.contactsData = contacts
                self.paginator?.fetchFirstPage()
            }
        }
    }

    func update(filterData: TransactionsFilterProperties) {
        if self.filterData != filterData {
            self.filterData = filterData

            if let tableView = historyTableView {
                topRefreshControl?.beginRefreshing(in: tableView)
            }

            paginator?.refresh()
        }
    }

    // MARK: - Setup tableView subviews

    private func setupTableViewFooter() {
        // set up label
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        footerView.backgroundColor = UIColor.clear

        // set up activity indicator
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = CGPoint(x: self.view.frame.width/2, y:22)
        activityIndicatorView.hidesWhenStopped = true

        self.bottomActivityIndicator = activityIndicatorView
        footerView.addSubview(activityIndicatorView)

        self.historyTableView?.tableFooterView = footerView
    }

    private func updateTableViewFooter() {
        if let provider = paginator, provider.reachedLastPage {
            self.historyTableView?.tableFooterView = UIView()
        } else {
            self.bottomActivityIndicator?.startAnimating()
        }
    }

    private func setupPlaceholder() {
        guard let tableView = historyTableView else {
            return
        }

        tableView.viewWithTag(199)?.removeFromSuperview()

        let rect = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 200)

        let view = IllustrationalPlaceholder(frame: rect)
        view.image = #imageLiteral(resourceName: "sadFace")
        view.tag = 199
        view.alpha = 0.0
        view.text = "Sorry, but you don’t have any history"
        view.textColor = .silver

        tableView.addSubview(view)

        view.center = CGPoint(x: tableView.bounds.width / 2, y: tableView.bounds.height / 3)

        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 1.0
        })
    }

    private func removePlaceholder() {
        guard let tableView = historyTableView else {
            return
        }

        tableView.viewWithTag(199)?.removeFromSuperview()
    }


    // MARK: - UIControl events

    @objc
    private func refreshControlValueChangedEvent(_ sender: UIRefreshControl) {
        setupTableViewFooter()
        topRefreshControl?.beginRefreshing()
        paginator?.refresh()
    }

    @objc
    private func filterButtonTouchUpInsideEvent(_ sender: UIButton) {
        onFilter?(filterData)
    }
}

// MARK: - Extensions

/**
 Extension implements UITableViewDataSource protocol.
 */
extension TransactionsHistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return paginator?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let provider = paginator, section < provider.results.count else {
            fatalError()
        }

        return provider.results[section].transactions.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let _header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TransactionsGroupHeaderComponent")

        guard let header = _header as? TransactionsGroupHeaderComponent else {
            return nil
        }

        guard let provider = paginator, section < provider.results.count else {
            return UIView()
        }

        let data = provider.results[section]
        header.configure(date: DateInterval.walletString(from: data.dateInterval), amount: data.amount.description(property: .usd))

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCellComponent", for: indexPath)

        guard let cell = _cell as? TransactionCellComponent else {
            fatalError()
        }

        guard let provider = paginator,
            indexPath.section < provider.results.count,
            indexPath.row < provider.results[indexPath.section].transactions.count else {
                return UITableViewCell()
        }

        let data = provider.results[indexPath.section].transactions[indexPath.row]

        var recipient: String = data.participant

        if let number = data.participantPhoneNumber {
            recipient = number.formattedString
        }

        if let contact = data.contact {
            recipient = contact.name
        }

        cell.configure(image: data.coin.image, status: data.status.formatted, coinShort: data.coin.short, recipient: recipient, amount: data.amount.original.formatted ?? "", fiatAmount: data.amount.description(property: .usd), direction: data.direction)

        return cell
    }
}

/**
 Extension implements UITableViewDelegate protocol.
 */
extension TransactionsHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // when reaching bottom, load a new page
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height {

            // ask next page only if we haven't reached last page
            if let last = paginator?.reachedLastPage, last == false {
                self.paginator?.fetchNextPage()
            }
        }
    }
}
