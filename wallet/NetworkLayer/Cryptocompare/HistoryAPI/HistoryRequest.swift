//
//  HistoryRequest.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum HistoryRequest: Request {

    case getDailyPrice(coin: String, toCoin: String, aggregate: Int?, limit: Int)
    case getHourlyPrice(coin: String, toCoin: String, aggregate: Int?, limit: Int)
    case getMinutePrice(coin: String, toCoin: String, aggregate: Int?, limit: Int)

    var path: String {
        switch self {
        case .getDailyPrice:
            return "data/histoday"
        case .getHourlyPrice:
            return "data/histohour"
        case .getMinutePrice:
            return "data/histominute"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: RequestParams? {
        switch self {
        case let .getDailyPrice(coin: coin, toCoin: toCoin, aggregate: aggregate, limit: limit):
            let dict = [
                "fsym": coin,
                "tsym": toCoin,
                "limit": String(limit),
                "aggregate": String(aggregate)
            ]

            return .url(dict.unwrapped())

        case let .getHourlyPrice(coin: coin, toCoin: toCoin, aggregate: aggregate, limit: limit):
            let dict = [
                "fsym": coin,
                "tsym": toCoin,
                "limit": String(limit),
                "aggregate": String(aggregate)
            ]

            return .url(dict.unwrapped())

        case let .getMinutePrice(coin: coin, toCoin: toCoin, aggregate: aggregate, limit: limit):
            let dict = [
                "fsym": coin,
                "tsym": toCoin,
                "limit": String(limit),
                "aggregate": String(aggregate)
            ]

            return .url(dict.unwrapped())
        }
    }

    var headers: [String : Any]? {
        return nil
    }
}
