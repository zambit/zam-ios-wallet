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
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .extraSmall
        case 1136:
            return .small
        case 1334:
            return .medium
        case 1920, 2208:
            return .plus
        case 2436:
            return .extra
        case 1792, 2688:
            return .extraLarge
        default:
            return .unknown
        }
    }
}
