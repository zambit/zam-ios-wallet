//
//  WalletDetailsSwitcherViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletDetailsSwitcherViewData: WalletDetailsViewData, Equatable {

    enum ChoiceType {
        case left
        case right
    }

    var type: WalletDetailsCellType {
        return .switcher
    }

    let choiceLeft: String
    let choiceRight: String
    let currentChoice: ChoiceType
}
