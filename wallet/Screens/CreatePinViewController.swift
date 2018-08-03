//
//  CreatePinViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreatePinViewController: WalletViewController, DecimalKeyboardComponentDelegate {

    var userManager: WalletUserDefaultsManager?

    var onContinue: ((_ authToken: String) -> Void)?
    var onSkip: (() -> Void)?

    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?
    @IBOutlet var createPinComponent: CreatePinComponent?

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardComponent?.delegate = self

        setupDefaultStyle()

        walletNavigationController?.addRightBarItemButton(title: "SKIP", target: self, action: #selector(skipButtonTouchEvent(_:)))
    }

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key) {
        switch key {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            createPinComponent?.currentPinStage?.dotsFieldComponent?.fillLast()
        case .remove:
            createPinComponent?.currentPinStage?.dotsFieldComponent?.unfillLast()
        case .touchId:
            break
        }

        print(key.rawValue)
    }

    @objc
    private func skipButtonTouchEvent(_ sender: UIBarButtonItem) {
        onSkip?()
    }
}
