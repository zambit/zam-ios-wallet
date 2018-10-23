//
//  CodableCoinDataResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 23/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableCoinDataResponse: Codable {

    let raw: [String: [String: CodableCoinData]]

    private enum CodingKeys: String, CodingKey {
        case raw = "RAW"
    }
}
