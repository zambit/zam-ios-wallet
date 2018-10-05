//
//  WalletEnvironment.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletEnvironment: Environment {

    var host: String {
        return "https://api-test.zam.io/api/v1"
    }

    var headers: [String : Any] {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}