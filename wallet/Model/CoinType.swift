//
//  CoinType.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

enum CoinType: String, Equatable {
    
    case eth
    case btc
    case bch
    case zam

    var image: UIImage {
        switch self {
        case .bch:
            return #imageLiteral(resourceName: "bitcoinCash")
        case .btc:
            return #imageLiteral(resourceName: "bitcoin")
        case .eth:
            return #imageLiteral(resourceName: "ethereum")
        case .zam:
            return #imageLiteral(resourceName: "zam")
        }
    }

    var name: String {
        switch self {
        case .bch:
            return "BitcoinCash"
        case .btc:
            return "Bitcoin"
        case .eth:
            return "Ethereum"
        case .zam:
            return "ZAM"
        }
    }

    var short: String {
        switch self {
        case .bch:
            return "BCH"
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        case .zam:
            return "ZAM"
        }
    }

    static var standard: CoinType {
        return .btc
    }
}
