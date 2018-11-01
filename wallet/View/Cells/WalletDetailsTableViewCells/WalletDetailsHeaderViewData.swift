//
//  WalletDetailsHeaderViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 01/11/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

enum WalletDetailsHeaderType {
    case transaction
}

protocol WalletDetailsHeaderViewData {

    var type: WalletDetailsHeaderType { get }
}
