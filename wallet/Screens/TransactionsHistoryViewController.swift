//
//  TransactionsHistoryViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsHistoryViewController: WalletViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var onFilter: ((TransactionsFilterData) -> Void)?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var filterButton: UIButton?
    @IBOutlet var historyTableView: UITableView?

    private var paginator: Paginator<TransactionsGroupData>?

    private var topRefreshControl: UIRefreshControl?
    private var bottomActivityIndicator: UIActivityIndicatorView?

    private var filterData: TransactionsFilterData = TransactionsFilterData()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterButton?.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
        self.filterButton?.addTarget(self, action: #selector(filterButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.historyTableView?.register(TransactionsGroupHeaderComponent.self, forHeaderFooterViewReuseIdentifier: "TransactionsGroupHeaderComponent")
        self.historyTableView?.register(TransactionCellComponent.self , forCellReuseIdentifier: "TransactionCellComponent")
        self.historyTableView?.delegate = self
        self.historyTableView?.dataSource = self

        self.view.applyDefaultGradientHorizontally()

        topRefreshControl = UIRefreshControl()
        topRefreshControl?.addTarget(self, action: #selector(refreshControlValueChangedEvent(_:)), for: .valueChanged)
        topRefreshControl?.layer.zPosition = -2
        historyTableView?.insertSubview(topRefreshControl!, at: 0)

        self.setupTableViewFooter()

        self.paginator = Paginator<TransactionsGroupData>(pageSize: 15, fetchHandler: {
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
            strongSelf.userAPI?.getTransactions(token: token, filter: strongSelf.filterData).done {
                page in

                paginator.receivedResults(results: page.transactions, next: page.next ?? "")
            }.catch {
                error in

                paginator.failed()
            }

        }, resultsHandler: {
            [weak self]
            (paginator, old, new) in

            self?.topRefreshControl?.endRefreshing()

            if paginator.results.isEmpty {
                self?.setupPlaceholder()
            } else {
                self?.removePlaceholder()
            }

            paginator.results.forEach {
                print("\(DateInterval.walletString(from: $0.dateInterval)) \($0.transactions.count)")
            }

            if old.isEmpty {
                self?.historyTableView?.reloadData()
                self?.updateTableViewFooter()
                return
            }

            // Pagination

            var indexPaths: [IndexPath] = []

            // Check for intersections
            if let last = old.last, let first = new.first, last.dateInterval == first.dateInterval {

                let sumAmount = try! last.amount.sum(with: first.amount)
                let transactions = last.transactions + first.transactions

                let concatiatedElement = TransactionsGroupData(dateInterval: last.dateInterval, amount: sumAmount, transactions: transactions)

                let concatiatedResults = Array(old[0..<old.count - 1]) + [concatiatedElement] + Array(new[1..<new.count])

                // Update results
                paginator.results = concatiatedResults

                // Update header
                guard let header = self?.historyTableView?.headerView(forSection: old.count - 1) as? TransactionsGroupHeaderComponent else {
                    fatalError()
                }
                header.set(amount: concatiatedElement.amount.description(currency: .usd))

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
            }, failureHandler: {
                [weak self]
                paginator in

                paginator.reset()
                self?.historyTableView?.reloadData()
        })

        self.topRefreshControl?.beginRefreshing()
        self.paginator?.fetchFirstPage()
    }

    func update(filterData: TransactionsFilterData) {
        if self.filterData != filterData {
            self.filterData = filterData

            if let tableView = historyTableView {
                topRefreshControl?.beginRefreshing(in: tableView)
            }

            paginator?.reload()
        }
    }

    // MARK: - UITableViewDataSource

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
        header.configure(date: DateInterval.walletString(from: data.dateInterval), amount: data.amount.description(currency: .usd))

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46.0
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
        cell.configure(image: data.coin.image, status: data.status.formatted, coinShort: data.coin.short, recipient: data.participant.formatted, amount: data.amount.formatted(currency: .original), fiatAmount: data.amount.description(currency: .usd), direction: data.direction)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // when reaching bottom, load a new page
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height {

            // ask next page only if we haven't reached last page
            if let last = paginator?.reachedLastPage, last == false {
                self.paginator?.fetchNextPage()
            }
        }
    }

    // MARK: - Setup tableView subviews

    private func setupTableViewFooter() {
        // set up label
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        footerView.backgroundColor = UIColor.clear

        // set up activity indicator
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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

        let view = IllustrationalPlaceholder(frame: tableView.bounds)
        view.tag = 199
        view.alpha = 0.0

        tableView.addSubview(view)

        view.center = CGPoint(x: tableView.bounds.width / 2, y: tableView.bounds.height / 2)

        UIView.animate(withDuration: 0.1, animations: {
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
        paginator?.reload()
    }

    @objc
    private func filterButtonTouchUpInsideEvent(_ sender: UIButton) {
        onFilter?(filterData)
    }
}
