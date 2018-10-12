//
//  CodableCoinHistoricalData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableCoinHistoricalData: Codable {
    let time: Double
    let close: Decimal
    let high: Decimal
    let low: Decimal
    let open: Decimal
    let volumeFrom: Decimal
    let volumeTo: Decimal

    private enum CodingKeys: String, CodingKey {
        case time
        case close
        case high
        case low
        case open
        case volumeFrom = "volumefrom"
        case volumeTo = "volumeto"
    }
}
