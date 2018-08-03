//
//  EnterPinViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterPinViewController: WalletViewController, DecimalKeyboardComponentDelegate {

    var userManager: WalletUserDefaultsManager?
    var authAPI: AuthAPI?

    var onContinue: ((_ authToken: String) -> Void)?

    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardComponent?.delegate = self

        setupDefaultStyle()
    }

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key) {
        print(key.rawValue)
    }
}
