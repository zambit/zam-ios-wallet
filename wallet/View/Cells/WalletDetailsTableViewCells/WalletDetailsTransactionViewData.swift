//
//  WalletDetailsTransactionViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

struct WalletDetailsTransactionViewData: WalletDetailsViewData, Equatable {

    var type: WalletDetailsCellType {
        return .transaction
    }

    let image: UIImage
    let status: String
    let coinShort: String
    let recipient: String
    let amount: String
    let fiatAmount: String
    let direction: DirectionType
}
