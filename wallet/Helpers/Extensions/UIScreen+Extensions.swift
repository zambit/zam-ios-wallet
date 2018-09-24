//
//  UIScreen+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIScreen {

    var type: ScreenType {
        switch UIScreen.main.bounds.height {
        case 480:
            return .extraSmall
        case 568:
            return .small
        case 667:
            return .medium
        case 736:
            return .plus
        case 812:
            return .extra
        case 896:
            return .extraLarge
        default:
            return .unknown
        }
    }
}
