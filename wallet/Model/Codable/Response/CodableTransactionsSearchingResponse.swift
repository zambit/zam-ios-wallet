//
//  CodableTransactionsSearchingResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableTransactionsSearchingResponse: Codable {

    let result: Bool
    let data: TransactionsPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct TransactionsPage: Codable {
        let count: Int
        let next: String?
        let transactions: [CodableTransaction]

        private enum CodingKeys: String, CodingKey {
            case count
            case next
            case transactions
        }
    }
}
