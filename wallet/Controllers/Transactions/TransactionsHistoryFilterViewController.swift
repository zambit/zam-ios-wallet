//
//  TransactionsHistoryFilterViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

/**
 Transactions history filter screen controlling entering history filters.
 */
class TransactionsHistoryFilterViewController: FlowViewController, WalletNavigable {

    var onDone: ((TransactionsFilterProperties) -> Void)?

    @IBOutlet private var componentsTableView: UITableView?

    private var filterComponents: [CellComponent] = []

    private var filterData: TransactionsFilterProperties?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        walletNavigationController?.custom.addRightDetailButton(in: self, title: "DONE", target: self, action: #selector(doneButtonTouchEvent(_:)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkIndigo

        isKeyboardHidesOnTap = true

        componentsTableView?.allowsSelection = false
        componentsTableView?.backgroundColor = .clear
        componentsTableView?.separatorStyle = .none
        componentsTableView?.alwaysBounceVertical = false
        componentsTableView?.delegate = self
        componentsTableView?.dataSource = self
    }

    private func setupComponents(filterData: TransactionsFilterProperties) {

        // Transaction date component
        let datesComponent = TransactionsGroupingFilterComponent(frame: .zero)
        datesComponent.setTitle("Transaction date")

        let groupings: [GroupingType] = [.day, .week, .month]
        var currentGroup: [Int] = []
        if let currentGroupIndex = groupings.index(of: filterData.group) {
            currentGroup = [currentGroupIndex]
        }

        datesComponent.prepare(groupings: groupings, selectedIndexes: currentGroup)
        datesComponent.insets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        datesComponent.onFilterChanged = {
            [weak self]
            selectedDates in

            guard let selected = selectedDates.first else {
                return
            }

            self?.filterData?.group = selected
        }
        filterComponents.append(datesComponent)


        // Select dates component
        let dateIntervalComponent = TransactionsDateIntervalFilterComponent(frame: .zero)
        dateIntervalComponent.setTitle("Select dates")
        dateIntervalComponent.insets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)

        var fromDate: Date?
        if let fromString = filterData.fromTime, let fromDouble = Double(fromString) {
            fromDate = Date(unixTimestamp: fromDouble)
        }

        var untilDate: Date?
        if let untilString = filterData.untilTime, let untilDouble = Double(untilString) {
            untilDate = Date(unixTimestamp: untilDouble)
        }
        
        dateIntervalComponent.prepare(from: fromDate, to: untilDate)
        dateIntervalComponent.onFilterChanged = {
            [weak self]
            from, until in

            if let from = from {
                self?.filterData?.fromTime = String(Int(from.unixTimestamp))
            }

            if let until = until {
                self?.filterData?.untilTime = String(Int(until.unixTimestamp))
            }
        }
        filterComponents.append(dateIntervalComponent)


        // Operation component
        let directionsComponent = TransactionsDirectionFilterComponent(frame: .zero)
        directionsComponent.setTitle("Operation")

        let directions: [DirectionType] = [.outgoing, .incoming]
        var currentDirection: [Int] = []
        if let direction = filterData.direction,
            let currentDirectionIndex = directions.index(of: direction) {

            currentDirection = [currentDirectionIndex]
        }

        directionsComponent.prepare(directions: directions, selectedIndexes: currentDirection)
        directionsComponent.insets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        directionsComponent.onFilterChanged = {
            [weak self]
            selectedDirections in

            guard let selected = selectedDirections.first else {
                self?.filterData?.direction = nil
                return
            }

            self?.filterData?.direction = selected
        }
        filterComponents.append(directionsComponent)


        // Coins component
        let coinsComponent = TransactionsCoinFilterComponent(frame: .zero)
        coinsComponent.setTitle("Coins")

        let coins: [CoinType] = [.btc, .bch, .eth, .zam]
        var currentCoin: [Int] = []
        if let coin = filterData.coin,
            let currentCoinIndex = coins.index(of: coin) {

            currentCoin = [currentCoinIndex]
        }

        coinsComponent.prepare(coins: coins, selectedIndexes: currentCoin)
        coinsComponent.insets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        coinsComponent.onFilterChanged = {
            [weak self]
            selectedCoins in

            self?.filterData?.coin = selectedCoins.first
        }
        filterComponents.append(coinsComponent)
    }

    func prepare(filterData: TransactionsFilterProperties) {
        self.filterData = filterData

        setupComponents(filterData: filterData)
    }

    @objc
    private func doneButtonTouchEvent(_ sender: Any) {
        if let filter = filterData {
            onDone?(filter)
        }
    }
}

// MARK: - Extensions

/**
 Extension implements UITableViewDataSource protocol.
 */
extension TransactionsHistoryFilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterComponents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return filterComponents[indexPath.item]
    }
}

/**
 Extension implements UITableViewDelegate protocol.
 */
extension TransactionsHistoryFilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return filterComponents[indexPath.item].intrinsicContentSize.height
    }
}
