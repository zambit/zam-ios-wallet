//
//  WalletDetailsInformationViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletDetailsInformationViewData: WalletDetailsViewData, Equatable {

    var type: WalletDetailsCellType {
        return .information
    }

    let title: String
    let detailValue: String
}
