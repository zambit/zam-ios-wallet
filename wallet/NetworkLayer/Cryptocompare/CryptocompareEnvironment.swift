//
//  CryptocompareEnvironment.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CryptocompareEnvironment: Environment {

    var host: String {
        return "https://min-api.cryptocompare.com"
    }

    var headers: [String : Any] {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}
