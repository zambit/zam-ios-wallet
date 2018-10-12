//
//  TransactionsGroup.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct TransactionsGroup: Equatable {

    let dateInterval: DateInterval
    let amount: Balance
    let transactions: [Transaction]

    init(codable: CodableTransactionsGroup) throws {
        self.dateInterval = DateInterval(startUnixTimestamp: codable.startDate, endUnixTimestamp: codable.endDate)

        self.amount = try Balance(coin: .btc, codable: codable.amount)

        self.transactions = try codable.transactions.map {
            try Transaction(codable: $0)
        }
    }

    init(dateInterval: DateInterval, amount: Balance, transactions: [Transaction]) {
        self.dateInterval = dateInterval
        self.amount = amount
        self.transactions = transactions
    }

    
}
