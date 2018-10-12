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

    init(codable: CodableCoinData) throws {
        guard let coin = CoinType(rawValue: codable.coin.lowercased()) else {
            throw CoinPriceError.coinTypeInputFormatError
        }
        self.coin = coin

        guard let fiat = FiatType(rawValue: codable.fiat.lowercased()) else {
            throw CoinPriceError.fiatTypeInputFormatError
        }
        self.fiat = fiat

        self.price = codable.price

        self.marketCap = codable.marketCap

        self.volumeDay = codable.volumeDay
        self.volume24h = codable.volume24h

        self.changePct24h = codable.changePct24h
        self.change24h = codable.change24h

        self.openDay = codable.openDay
        self.highDay = codable.highDay
        self.lowDay = codable.lowDay

        self.open24h = codable.open24h
        self.high24h = codable.high24h
        self.low24h = codable.low24h

        self.supply = codable.supply
    }
}

enum CoinPriceError: Error {

    case coinTypeInputFormatError
    case fiatTypeInputFormatError
}
