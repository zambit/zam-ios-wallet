//
//  CodableTransactionsGroup.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableTransactionsGroup: Codable {

    let startDate: Double
    let endDate: Double
    let amount: CodableBalance
    let transactions: [CodableTransaction]

    private enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case amount = "total_amount"
        case transactions = "items"
    }
}
