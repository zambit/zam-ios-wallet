//
//  PriceRequest.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum PriceRequest: Request {

    case getPrice(coin: String, toCoin: String)
    case getDetailPrice(coin: String, toCoin: String)

    var path: String {
        switch self {
        case .getPrice:
            return "data/price"
        case .getDetailPrice:
            return "data/pricemultifull"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: RequestParams? {
        switch self {
        case let .getPrice(coin: coin, toCoin: toCoin):
            return .url([
                "fsym": coin,
                "tsyms": toCoin
                ])
        case let .getDetailPrice(coin: coin, toCoin: toCoin):
            return .url([
                "fsyms": coin,
                "tsyms": toCoin
                ])
        }
    }

    var headers: [String : Any]? {
        return nil
    }
}

