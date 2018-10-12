//
//  CodableBalance.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableBalance: Codable {

    let zam: String?
    let eth: String?
    let btc: String?
    let bch: String?
    let usd: String

    private enum CodingKeys: String, CodingKey {
        case zam
        case eth
        case btc
        case bch
        case usd
    }
}
