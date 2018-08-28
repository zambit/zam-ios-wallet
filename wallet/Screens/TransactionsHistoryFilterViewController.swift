//
//  TransactionsHistoryFilterViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsHistoryFilterViewController: WalletViewController, UITableViewDelegate, UITableViewDataSource {

    var onDone: (() -> Void)?

    @IBOutlet private var componentsTableView: UITableView?

    private var filterComponents: [CellComponent] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkIndigo

        hideKeyboardOnTap()

        setupComponents()

        componentsTableView?.backgroundColor = .clear
        componentsTableView?.separatorStyle = .none
        componentsTableView?.alwaysBounceVertical = false
        componentsTableView?.delegate = self
        componentsTableView?.dataSource = self
    }

    private func setupComponents() {
        let datesComponent = TransactionsFeatureFilterComponent(frame: .zero)
        datesComponent.setTitle("Transaction date")
        datesComponent.prepare(features: ["Week", "Month", "Year"], isMultipleSelecting: false)
        datesComponent.insets = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)

        filterComponents.append(datesComponent)

        let dateIntervalComponent = TransactionsDateIntervalFilterComponent(frame: .zero)
        dateIntervalComponent.setTitle("Select dates")
        dateIntervalComponent.insets = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)

        filterComponents.append(dateIntervalComponent)

        let directionsComponent = TransactionsFeatureFilterComponent(frame: .zero)
        directionsComponent.setTitle("Operation")
        directionsComponent.prepare(features: ["Sent", "Received"], isMultipleSelecting: true)
        directionsComponent.insets = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)

        filterComponents.append(directionsComponent)

        let coinsComponent = TransactionsCoinFilterComponent(frame: .zero)
        coinsComponent.setTitle("Coins")
        coinsComponent.prepare(coins: [.btc, .bch, .eth])
        coinsComponent.insets = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)

        filterComponents.append(coinsComponent)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterComponents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return filterComponents[indexPath.item]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return filterComponents[indexPath.item].intrinsicContentSize.height
    }

}
