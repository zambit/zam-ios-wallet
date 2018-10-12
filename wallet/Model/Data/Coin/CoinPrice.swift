//
//  CoinFullData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CoinPrice: Equatable {

    let coin: CoinType

    let fiat: FiatType

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
}
