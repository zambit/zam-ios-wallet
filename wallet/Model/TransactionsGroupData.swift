//
//  TransactionsGroupData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct TransactionsGroupData {

    let dateInterval: DateInterval
    let amount: BalanceData
    let transactions: [TransactionData]

    init(codable: CodableTransactionsGroup) throws {
        self.dateInterval = DateInterval(startUnixTimestamp: codable.startDate, endUnixTimestamp: codable.endDate)

        self.amount = try BalanceData(coin: .btc, codable: codable.amount)

        self.transactions = try codable.transactions.map {
            try TransactionData(codable: $0)
        }
    }

    init(dateInterval: DateInterval, amount: BalanceData, transactions: [TransactionData]) {
        self.dateInterval = dateInterval
        self.amount = amount
        self.transactions = transactions
    }

    
}
