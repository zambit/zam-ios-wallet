//
//  Balance.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct Balance: Equatable {

    enum Currency {
        case usd
        case original
    }

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

    func description(currency: Currency) -> String {
        let string = formattedShort(currency: currency)

        switch currency {
        case .original:
            return "\(string) \(coin.short.uppercased())"
        case .usd:
            return "$ \(string)"
        }
    }

    func formattedShort(currency: Currency) -> String {
        switch currency {
        case .original:
            guard let formatted = original.shortFormatted else {
                fatalError()
            }
            return formatted
        case .usd:
            guard let formatted = usd.shortFormatted else {
                fatalError()
            }
            return formatted
        }
    }

    func formatted(currency: Currency) -> String {
        switch currency {
        case .original:
            guard let formatted = original.longFormatted else {
                fatalError()
            }
            return formatted
        case .usd:
            guard let formatted = usd.longFormatted else {
                fatalError()
            }
            return formatted
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
