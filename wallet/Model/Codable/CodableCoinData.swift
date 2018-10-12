//
//  CodableCoinData.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableCoinData: Codable {

    let coin: String
    let fiat: String

    let price: Decimal

    let marketCap: Decimal

    let volumeDay: Decimal
    let volume24h: Decimal

    let changePct24h: Decimal
    let change24h: Decimal

    let openDay: Decimal
    let highDay: Decimal
    let lowDay: Decimal

    let open24h: Decimal
    let high24h: Decimal
    let low24h: Decimal

    let supply: Decimal

    private enum CodingKeys: String, CodingKey {
        case coin = "FROMSYMBOL"
        case fiat = "TOSYMBOL"

        case price = "PRICE"

        case marketCap = "MKTCAP"

        case volumeDay = "VOLUMEDAY"
        case volume24h = "VOLUME24HOUR"

        case changePct24h = "CHANGEPCT24HOUR"
        case change24h = "CHANGE24HOUR"

        case openDay = "OPENDAY"
        case highDay = "HIGHDAY"
        case lowDay = "LOWDAY"

        case open24h = "OPEN24HOUR"
        case high24h = "HIGH24HOUR"
        case low24h = "LOW24HOUR"

        case supply = "SUPPLY"
    }
}
