//
//  Amount.swift
//  wallet
//
//  Created by Александр Пономарев on 24/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct Amount {

    let coin: CoinType
    let fiat: FiatType

    var coinPrice: CoinPrice?

    let value: Decimal

    var fiatValue: Decimal? {
        guard let price = coinPrice else {
            return nil
        }

        return price.price * value
    }

    init(value: Decimal, coin: CoinType, fiat: FiatType, coinPrice: CoinPrice? = nil) {
        self.value = value
        self.coin = coin
        self.fiat = fiat
        self.coinPrice = coinPrice
    }
}
