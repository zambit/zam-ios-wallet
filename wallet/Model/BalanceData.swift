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

    let usd: Float
    let original: Float

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
            let original = NumberFormatter.walletAmount.number(from: strNumber)?.floatValue,
            let usd = NumberFormatter.walletAmount.number(from: codable.usd)?.floatValue else {
            fatalError()
        }

        self.usd = usd
        self.original = original
    }

    var formattedUsd: String {
        return "$ \(usd)"
    }

    var formattedOriginal: String {
        return String(original)
    }
}
