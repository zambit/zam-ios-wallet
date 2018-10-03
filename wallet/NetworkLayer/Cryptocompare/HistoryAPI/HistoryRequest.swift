//
//  HistoryRequest.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum HistoryRequest: Request {

    case getDailyData(coin: String, toCoin: String, limit: Int)

    var path: String {
        switch self {
        case .getDailyData:
            return "data/histoday"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDailyData:
            return .get
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .getDailyData(coin: coin, toCoin: toCoin, limit: limit):
            return .url([
                "fsym": coin,
                "tsym": toCoin,
                "limit": String(limit)
                ])
        }
    }

    var headers: [String : Any]? {
        return nil
    }
}
