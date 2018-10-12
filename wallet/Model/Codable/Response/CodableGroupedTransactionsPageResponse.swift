//
//  CodableGroupedTransactionsPageResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableGroupedTransactionsPageResponse: Codable {

    let result: Bool
    let data: CodablePage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct CodablePage: Codable {
        let count: Int
        let next: String?
        let transactions: [CodableTransactionsGroup]?

        private enum CodingKeys: String, CodingKey {
            case count
            case next
            case transactions
        }
    }
}
