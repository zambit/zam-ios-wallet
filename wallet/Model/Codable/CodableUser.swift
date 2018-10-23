//
//  CodableUser.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableUser: Codable {

    let id: String
    let phone: String
    let status: String
    let registeredAt: Decimal
    let wallets: CodableWallets

    private enum CodingKeys: String, CodingKey {
        case id
        case phone
        case status
        case registeredAt = "registered_at"
        case wallets
    }

    struct CodableWallets: Codable {
        let count: Int
        let totalBalance: CodableBalance

        private enum CodingKeys: String, CodingKey {
            case count
            case totalBalance = "total_balance"
        }
    }
}
