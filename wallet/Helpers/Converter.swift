
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

    var amount: Decimal?

    init(price: CoinPrice) {
        self.price = price
    }

    var converted: Decimal? {
        guard let amount = amount else {
            return nil
        }

        return price.price * amount
    }
}
