//
//  KeychainConfiguratio.swift
//  wallet
//
//  Created by  me on 06/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletKeychainConfiguration: KeychainConfiguration {
    
    var serviceName: String {
        return "ZamZamWalletService"
    }

    var accessGroup: String? {
        return nil
    }
}
