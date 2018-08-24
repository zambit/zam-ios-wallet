//
//  TransactionsHistoryViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsHistoryViewController: WalletViewController {

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var historyTableView: UITableView?

    private var transactions: [TransactionData] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    private func loadData() {
        guard let token = userManager?.getToken() else {
            fatalError()
        }

        userAPI?.getUserInfo(token: token, coin: nil).done {
            [weak self]
            info in

            }.catch {
                [weak self]
                error in
                print(error)
        }
    }



}
