//
//  TransactionsDirectionFilterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 29/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class TransactionsDirectionFilterComponent: TransactionsFeatureFilterComponent {

    var onFilterChanged: (([DirectionType]) -> Void)?

    override var nibName: String {
        return "TransactionsFeatureFilterComponent"
    }

    func prepare(directions: [DirectionType], selectedIndexes: [Int] = []) {
        super.prepare(features: directions.map { $0.formatted }, selectedIndexes: selectedIndexes)
    }

    override func selectedFeaturesWasUpdated(_ features: [String]) {
        super.selectedFeaturesWasUpdated(features)

        let directions = features.compactMap {
            DirectionType(formatted: $0)
        }

        onFilterChanged?(directions)
    }
}
