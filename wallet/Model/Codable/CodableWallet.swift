//
//  CodableWallet.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableWallet: Codable {

    let id: String
    let coin: String
    let name: String
    let address: String
    let balances: CodableBalance

    private enum CodingKeys: String, CodingKey {
        case id
        case coin
        case name = "wallet_name"
        case address
        case balances
    }
}
