//
//  BalanceData.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct BalanceData {

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

    init(coin: CoinType, codable: CodableBalance) {
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

        guard
            let strNumber = stringNumber,
            let original = NumberFormatter.walletAmount.number(from: strNumber)?.decimalValue,
            let usd = NumberFormatter.walletAmount.number(from: codable.usd)?.decimalValue else {
            fatalError()
        }

        self.usd = usd
        self.original = original
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
            guard let formatted = NumberFormatter.walletAmountShort.string(from: original as NSNumber) else {
                fatalError()
            }
            return formatted
        case .usd:
            guard let formatted = NumberFormatter.walletAmountShort.string(from: usd as NSNumber) else {
                fatalError()
            }
            return formatted
        }
    }

    func formatted(currency: Currency) -> String {
        switch currency {
        case .original:
            guard let formatted = NumberFormatter.walletAmount.string(from: original as NSNumber) else {
                fatalError()
            }
            return formatted
        case .usd:
            guard let formatted = NumberFormatter.walletAmount.string(from: usd as NSNumber) else {
                fatalError()
            }
            return formatted
        }
    }
}
