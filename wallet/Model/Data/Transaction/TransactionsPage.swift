//
//  TransactionsPage.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct TransactionsPage: Equatable {

    let next: String?
    let transactions: [TransactionsGroup]

    init(codable: CodableGroupedTransactionsPageResponse.CodablePage) throws {
        self.next = codable.next

        self.transactions = try codable.transactions?.map {
            try TransactionsGroup(codable: $0)
        } ?? []
    }

    init(next: String?, transactions: [TransactionsGroup]) {
        self.next = next
        self.transactions = transactions
    }
}
