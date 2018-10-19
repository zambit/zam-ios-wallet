//
//  Double+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 19/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Double {

    var formatted: String? {
        return Decimal(self).formatted
    }
}
