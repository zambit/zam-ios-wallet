//
//  CoinHistoricalPrice.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CoinHistoricalPrice: Equatable {

    let coin: CoinType
    let fiat: FiatType

    let time: Date

    let closePrice: Decimal
    let highPrice: Decimal
    let lowPrice: Decimal
    let openPrice: Decimal
    let volumeFrom: Decimal
    let volumeTo: Decimal

    init(coin: CoinType, fiat: FiatType, codable: CodableCoinHistoricalData) {
        self.coin = coin
        self.fiat = fiat

        self.time = Date(unixTimestamp: codable.time)

        self.closePrice = codable.close
        self.highPrice = codable.high
        self.lowPrice = codable.low
        self.openPrice = codable.open
        self.volumeFrom = codable.volumeFrom
        self.volumeTo = codable.volumeTo
    }

    enum Properties {
        case closePrice
        case highPrice
        case lowPrice
        case openPrice
        case volumeFrom
        case volumeTo
    }

    func description(property: Properties) -> String {
        var currency: String?

        switch property {
        case .closePrice:
            currency = closePrice.formatted
        case .highPrice:
            currency = highPrice.formatted
        case .lowPrice:
            currency = lowPrice.formatted
        case .openPrice:
            currency = openPrice.formatted
        case .volumeFrom:
            currency = volumeFrom.formatted
        case .volumeTo:
            currency = volumeTo.formatted
        }

        if let string = currency {
            return "\(fiat.symbol) \(string)"
        }

        return ""
    }
}
