//
//  CoinDailyPriceData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CoinHistoricalPrice: Equatable {

    let coin: CoinType

    let time: Date

    let closePrice: Decimal
    let highPrice: Decimal
    let lowPrice: Decimal
    let openPrice: Decimal
    let volumeFrom: Decimal
    let volumeTo: Decimal

    init(coin: CoinType, codable: CodableCoinHistoricalData) {
        self.coin = coin

        self.time = Date(unixTimestamp: codable.time)

        self.closePrice = codable.close
        self.highPrice = codable.high
        self.lowPrice = codable.low
        self.openPrice = codable.open
        self.volumeFrom = codable.volumeFrom
        self.volumeTo = codable.volumeTo
    }
}
