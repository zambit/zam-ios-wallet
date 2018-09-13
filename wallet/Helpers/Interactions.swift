//
//  Interactions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 13/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import AudioToolbox
import UIKit

struct Interactions {

    static func vibrateError() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    static func vibrateSuccess() {
        AudioServicesPlaySystemSound(1519)
    }
}

