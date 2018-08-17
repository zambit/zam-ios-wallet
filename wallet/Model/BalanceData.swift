//
//  BalanceData.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct BalanceData {

    let coin: CoinType

    let usd: Decimal
    let original: Decimal

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

    var formattedUsdShort: String {
        guard let formatted = NumberFormatter.walletAmountShort.string(from: usd as NSNumber) else {
            fatalError()
        }
        return "$ \(formatted)"
    }

    var formattedUsd: String {
        guard let formatted = NumberFormatter.walletAmount.string(from: usd as NSNumber) else {
            fatalError()
        }
        return "$ \(formatted)"
    }

    var formattedOriginalShort: String {
        guard let formatted = NumberFormatter.walletAmountShort.string(from: original as NSNumber) else {
            fatalError()
        }
        return "\(formatted)"
    }

    var formattedOriginal: String {
        guard let formatted = NumberFormatter.walletAmount.string(from: original as NSNumber) else {
            fatalError()
        }
        return "\(formatted) \(coin.short.uppercased())"
    }
}
