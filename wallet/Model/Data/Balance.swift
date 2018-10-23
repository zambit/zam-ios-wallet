//
//  Balance.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct Balance: Equatable {

    let coin: CoinType

    let usd: Decimal
    let original: Decimal

    init(coin: CoinType, usd: Decimal, original: Decimal) {
        self.coin = coin
        self.usd = usd
        self.original = original
    }

    init(coin: CoinType, codable: CodableBalance) throws {
        self.coin = coin

        var stringNumber: String?

        switch coin {
        case .eth:
            stringNumber = codable.eth
        case .btc:
            stringNumber = codable.btc
        case .bch:
            stringNumber = codable.bch
        case .zam:
            stringNumber = codable.zam
        }

        guard let strNumber = stringNumber else {
            throw BalanceDataError.coinValueNotFound
        }

        guard let original = Decimal(string: strNumber),
            let usd = Decimal(string: codable.usd) else {
            throw BalanceDataError.decimalFormatsResponseError
        }

        self.usd = usd
        self.original = original
    }

    static func empty(coin: CoinType) -> Balance {
        return Balance(coin: coin, usd: 0.0, original: 0.0)
    }

    func sum(with another: Balance) throws -> Balance {
        guard coin == another.coin else {
            throw BalanceDataError.sumDefferentCoinBalance
        }

        return Balance(coin: coin, usd: usd + another.usd, original: original + another.original)
    }

    enum Properties {
        case usd
        case original
    }

    func description(property: Properties) -> String {
        switch property {
        case .original:
            if let string = original.formatted {
                return "\(string) \(coin.short.uppercased())"
            }

            return ""
        case .usd:
            if let string = usd.shortFormatted {
                return "$ \(string)"
            }

            return ""
        }
    }

    var negative: Balance {
        let balance = Balance(coin: coin, usd: -usd, original: -original)
        return balance
    }
}

enum BalanceDataError: Error {
    case coinValueNotFound
    case decimalFormatsResponseError
    case sumDefferentCoinBalance
}
