//
//  GroupedTransactionsPageData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct GroupedTransactionsPageData: Equatable {

    let next: String?
    let transactions: [TransactionsGroupData]

    init(codable: CodableSuccessTransactionsGroupedSearchingResponse.GroupedTransactionsPage) throws {
        self.next = codable.next

        self.transactions = try codable.transactions?.map {
            try TransactionsGroupData(codable: $0)
        } ?? []
    }

    init(next: String?, transactions: [TransactionsGroupData]) {
        self.next = next
        self.transactions = transactions
    }
}
