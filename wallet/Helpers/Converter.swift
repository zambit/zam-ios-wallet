
//
//  Converter.swift
//  wallet
//
//  Created by Alexander Ponomarev on 23/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct AmountConverter {

    var price: CoinPrice

    init(price: CoinPrice) {
        self.price = price
    }

    func convert(_ amount: Decimal) -> Decimal {
        return price.price * amount
    }
}
