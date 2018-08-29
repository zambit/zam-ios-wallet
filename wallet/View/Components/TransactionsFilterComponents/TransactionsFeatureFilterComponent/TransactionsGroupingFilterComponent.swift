//
//  TransactionsGroupingFilterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 29/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class TransactionsGroupingFilterComponent: TransactionsFeatureFilterComponent {

    var onFilterChanged: (([GroupingType]) -> Void)?

    override var nibName: String {
        return "TransactionsFeatureFilterComponent"
    }

    func prepare(groupings: [GroupingType], selectedIndexes: [Int] = []) {
        super.prepare(features: groupings.map { $0.formatted }, selectedIndexes: selectedIndexes)
    }

    override func selectedFeaturesWasUpdated(_ features: [String]) {
        super.selectedFeaturesWasUpdated(features)

        let groupings = features.compactMap {
            GroupingType(formatted: $0)
        }

        onFilterChanged?(groupings)
    }
}
