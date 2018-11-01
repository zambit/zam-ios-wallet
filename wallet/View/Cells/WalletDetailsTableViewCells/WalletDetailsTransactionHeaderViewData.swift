//
//  WalletDetailsTransactionHeaderViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 31/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

struct WalletDetailsTransactionHeaderViewData: WalletDetailsHeaderViewData, Equatable {

    var type: WalletDetailsHeaderType {
        return .transaction
    }

    let date: String
    let amount: String
}
