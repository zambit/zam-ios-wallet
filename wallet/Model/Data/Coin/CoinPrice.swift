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
        var currency: String?
        var percents: String?

        switch property {
        case .price:
            currency = price.longFormatted
        case .marketCap:
            currency = marketCap.longFormatted
        case .volumeDay:
            currency = volumeDay.shortFormatted
        case .volume24h:
            currency = volume24h.shortFormatted
        case .changePct24h:
            percents = changePct24h.shortFormatted
        case .change24h:
            currency = change24h.shortFormatted
        case .openDay:
            currency = openDay.shortFormatted
        case .highDay:
            currency = highDay.shortFormatted
        case .lowDay:
            currency = lowDay.shortFormatted
        case .open24h:
            currency = open24h.shortFormatted
        case .high24h:
            currency = high24h.shortFormatted
        case .low24h:
            currency = low24h.shortFormatted
        case .supply:
            currency = supply.longFormatted
        }

        if let string = currency {
            return "\(fiat.symbol) \(string)"
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
