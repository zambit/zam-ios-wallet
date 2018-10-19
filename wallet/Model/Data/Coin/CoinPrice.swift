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

    enum Properties {
        case price
        case marketCap
        case volumeDay
        case volume24h
        case changePct24h
        case change24h
        case openDay
        case highDay
        case lowDay
        case open24h
        case high24h
        case low24h
        case supply
    }

    func description(property: Properties) -> String {
        var prefix: String?
        var currency: String?
        var percents: String?

        switch property {
        case .price:
            prefix = fiat.symbol
            currency = price.formatted
        case .marketCap:
            prefix = fiat.symbol
            currency = marketCap.formatted
        case .volumeDay:
            prefix = coin.short
            currency = volumeDay.formatted
        case .volume24h:
            prefix = coin.short
            currency = volume24h.formatted
        case .changePct24h:
            percents = changePct24h.shortFormatted
        case .change24h:
            prefix = fiat.symbol
            currency = change24h.shortFormatted
        case .openDay:
            prefix = fiat.symbol
            currency = openDay.shortFormatted
        case .highDay:
            prefix = fiat.symbol
            currency = highDay.shortFormatted
        case .lowDay:
            prefix = fiat.symbol
            currency = lowDay.shortFormatted
        case .open24h:
            prefix = fiat.symbol
            currency = open24h.shortFormatted
        case .high24h:
            prefix = fiat.symbol
            currency = high24h.shortFormatted
        case .low24h:
            prefix = fiat.symbol
            currency = low24h.shortFormatted
        case .supply:
            prefix = coin.short
            currency = supply.formatted
        }

        if let string = currency {
            if let prefix = prefix {
                return "\(prefix) \(string)"
            } else {
                return "\(string)"
            }
        }

        if let string = percents {
            return "\(string)%"
        }

        return ""
    }
}

enum CoinPriceError: Error {

    case coinTypeInputFormatError
    case fiatTypeInputFormatError
}
