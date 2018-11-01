//
//  Converter.swift
//  wallet
//
//  Created by Александр Пономарев on 25/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct Converter {

    let coin: CoinType
    let fiat: FiatType

    private var _coinValue: Decimal = 0.0
    private var _fiatValue: Decimal = 0.0

    var coinValue: Decimal {
        get {
            return _coinValue
        }
        set {
            _coinValue = newValue

            if let coinPrice = coinPrice {
                _fiatValue = newValue * coinPrice.price
            } else {
                _fiatValue = 0.0
            }
        }
    }


    var fiatValue: Decimal {
        get {
            return _fiatValue
        }
        set {
            _fiatValue = newValue

            if let coinPrice = coinPrice {
                _coinValue = newValue / coinPrice.price
            } else {
                _coinValue = 0.0
            }
        }
    }

    var coinPrice: CoinPrice?

    init(coin: CoinType, fiat: FiatType, coinPrice: CoinPrice? = nil) {
        self.coin = coin
        self.fiat = fiat
        self.coinPrice = coinPrice
    }

    var amount: Amount {
        return Amount(value: coinValue, coin: coin, fiat: fiat, coinPrice: coinPrice)
    }
}
