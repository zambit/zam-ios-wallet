//
//  SignUpFlow.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import FlowKit

class SignUpFlow {

    lazy var enterPhoneNumberScreen: Flow<EnterPhoneNumberViewController> = Flow {
        [unowned self]
        lets in

        let screen = EnterPhoneNumberViewController()
        screen.onContinue = lets.push(self.verifyPhoneNumberWithSmsScreen, animated: true) { $0.prepare }

        return screen
    }

    lazy var verifyPhoneNumberWithSmsScreen: Flow<VerifyPhoneNumberWithSmsViewController> = Flow {
        [unowned self]
        lets in

        let screen = VerifyPhoneNumberWithSmsViewController()

        return screen
    }
}
