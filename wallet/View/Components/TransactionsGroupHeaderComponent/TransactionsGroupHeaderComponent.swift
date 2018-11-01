//
//  TransactionsGroupHeaderComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsGroupHeaderComponent: HeaderFooterComponent, Configurable {

    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet var amountLabel: UILabel?

    override func setupStyle() {
        super.setupStyle()

        dateLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        dateLabel?.textColor = .blueGrey
        dateLabel?.textAlignment = .left

        amountLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .bold)
        amountLabel?.textColor = .darkIndigo
        amountLabel?.textAlignment = .right
    }

    func configure(with data: WalletDetailsTransactionHeaderViewData) {
        dateLabel?.text = data.date
        amountLabel?.text = data.amount
    }

    func configure(date: String, amount: String) {
        dateLabel?.text = date
        amountLabel?.text = amount
    }

    func set(amount: String) {
        amountLabel?.text = amount
    }
}
