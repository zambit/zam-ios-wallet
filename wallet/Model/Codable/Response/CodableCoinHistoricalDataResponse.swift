//
//  CodableCoinHistoricalDataResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableCoinHistoricalDataResponse: Codable {
    
    let data: [CodableCoinHistoricalData]
    let timeFrom: Double
    let timeTo: Double

    private enum CodingKeys: String, CodingKey {
        case data = "Data"
        case timeFrom = "TimeFrom"
        case timeTo = "TimeTo"
    }
}
