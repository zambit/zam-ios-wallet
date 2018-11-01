//
//  WalletDetailsViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 01/11/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

enum WalletDetailsCellType {
    case brief
    case chart
    case switcher
    case information
    case transaction
}

protocol WalletDetailsViewData {

    var type: WalletDetailsCellType { get }
}
