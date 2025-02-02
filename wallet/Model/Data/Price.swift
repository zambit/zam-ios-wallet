//
//  Price.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct Price: Equatable {

    let fiat: FiatType

    let amount: Decimal
}
