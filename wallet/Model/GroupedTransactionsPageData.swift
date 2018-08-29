//
//  GroupedTransactionsPageData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct GroupedTransactionsPageData {

    let next: String?
    let transactions: [TransactionsGroupData]

    init(codable: CodableSuccessTransactionsGroupedSearchingResponse.GroupedTransactionsPage) throws {
        self.next = codable.next

        self.transactions = try codable.transactions?.map {
            try TransactionsGroupData(codable: $0)
        } ?? []
    }
}
