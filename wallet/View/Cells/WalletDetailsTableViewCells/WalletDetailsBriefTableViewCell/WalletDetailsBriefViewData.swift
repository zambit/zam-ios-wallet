//
//  WalletDetailsBriefViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletDetailsBriefViewData: WalletDetailsViewData, Equatable {

    var type: WalletDetailsCellType {
        return .brief
    }

    let currentIndex: Int
    let wallets: [WalletItemData]

    let price: String?
    let change: String?
    let changePct: String?
    let isChangePositive: Bool?
}
