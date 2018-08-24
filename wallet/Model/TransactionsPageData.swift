//
//  TransactionsPageData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct TransactionsPageData {

    let next: String?
    let transactions: [TransactionData]

    init(codable: CodableSuccessTransactionsSearchingResponse.TransactionsPage) throws {
        self.next = codable.next

        self.transactions = try codable.transactions.map {
            try TransactionData(codable: $0)
        }
    }
}
