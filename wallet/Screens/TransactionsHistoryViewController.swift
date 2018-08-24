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

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var historyTableView: UITableView?

    private var paginator: Paginator<TransactionData>?

    private var refreshControl: UIRefreshControl?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.historyTableView?.register(TransactionCellComponent.self , forCellReuseIdentifier: "TransactionCellComponent")
        self.historyTableView?.delegate = self
        self.historyTableView?.dataSource = self

        self.view.applyDefaultGradientHorizontally()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChangedEvent(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -2
        historyTableView?.insertSubview(refreshControl!, at: 0)

        self.setupTableViewFooter()

        self.paginator = Paginator<TransactionData>(pageSize: 20, fetchHandler: {
            [weak self]
            (paginator: Paginator, pageSize: Int, nextPage: String?) in

            guard let token = self?.userManager?.getToken() else {
                fatalError()
            }

            self?.userAPI?.getTransactions(token: token, filter: UserAPI.GetTransactionsFilter(page: nextPage)).done {
                page in

                paginator.receivedResults(results: page.transactions, next: page.next ?? "")
                self?.refreshControl?.endRefreshing()

                }.catch {
                    error in
                    print(error)

                    paginator.failed()
            }

        }, resultsHandler: {
            [weak self]
            (paginator, results) in

            // update tableview footer
            self?.updateTableViewFooter()
            self?.activityIndicator.stopAnimating()

            var indexPaths: [IndexPath] = []
            var i = (paginator.results.count) - results.count
            for _ in results {
                indexPaths.append(IndexPath(row: i, section: 0))
                i += 1
            }
            self?.historyTableView?.beginUpdates()
            self?.historyTableView?.insertRows(at: indexPaths, with: .fade)
            self?.historyTableView?.endUpdates()

        })

        self.paginator?.fetchFirstPage()
    }

    var activityIndicator: UIActivityIndicatorView!
    var footerLabel: UILabel!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginator?.results.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCellComponent", for: indexPath)

        guard let cell = _cell as? TransactionCellComponent else {
            fatalError()
        }

        guard let provider = paginator, indexPath.row < provider.results.count else {
            fatalError()
        }

        let data = provider.results[indexPath.row]
        cell.configure(image: data.coin.image, status: data.status.formatted, coinShort: data.coin.short, recipient: data.participant.formatted, amount: data.amount.formatted(currency: .original), fiatAmount: data.amount.description(currency: .usd), direction: data.direction)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //super.scrollViewDidScroll(scrollView)

        // when reaching bottom, load a new page
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height {

            // ask next page only if we haven't reached last page
            if let last = paginator?.reachedLastPage, last == false {

                // fetch next page of results
                paginator?.fetchNextPage()
            }
        }
    }

    func fetchNextPage() {
        self.paginator?.fetchNextPage()
        self.activityIndicator.startAnimating()
    }

    func setupTableViewFooter() {
        // set up label
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        footerView.backgroundColor = UIColor.clear

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center;

        self.footerLabel = label
        footerView.addSubview(label)

        // set up activity indicator
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.center = CGPoint(x: 40, y:22)
        activityIndicatorView.hidesWhenStopped = true

        self.activityIndicator = activityIndicatorView;
        footerView.addSubview(activityIndicatorView)

        self.historyTableView?.tableFooterView = footerView;
    }

    func updateTableViewFooter() {
        if let provider = paginator, !provider.reachedLastPage {
            self.footerLabel.text = "Loading..."
        } else {
            self.footerLabel.text = ""
        }

        self.footerLabel.setNeedsDisplay()
    }

    @objc
    private func refreshControlValueChangedEvent(_ sender: UIRefreshControl) {
        refreshControl?.beginRefreshing()
        paginator?.reset()
        paginator?.fetchFirstPage()
    }
}
