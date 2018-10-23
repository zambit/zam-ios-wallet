//
//  WalletItemData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 08/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

struct WalletItemData {

    let name: String

    let icon: UIImage
    let short: String

    let phoneNumber: String

    let balance: String
    let fiatBalance: String

    init(data: Wallet, phoneNumber: String) {
        self.name = data.name
        self.icon = data.coin.image
        self.short = data.coin.short
        self.phoneNumber = phoneNumber

        self.balance = data.balance.original.formatted ?? ""
        self.fiatBalance = data.balance.description(property: .usd) 
    }
}
