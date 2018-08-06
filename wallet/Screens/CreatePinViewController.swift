//
//  CreatePinViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreatePinViewController: WalletViewController, DecimalKeyboardComponentDelegate, CreatePinComponentDelegate {

    var userManager: WalletUserDefaultsManager?

    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?

    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?
    @IBOutlet var createPinComponent: CreatePinComponent?

    private var pinText: String = "" {
        didSet {
            print(pinText)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardComponent?.delegate = self
        createPinComponent?.delegate = self

        setupDefaultStyle()
        walletNavigationController?.addRightBarItemButton(for: self, title: "SKIP", target: self, action: #selector(skipButtonTouchEvent(_:)))
    }

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key) {
        switch key {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            createPinComponent?.enterTheKey(key.rawValue)
        case .remove:
            createPinComponent?.removeLast()
        case .touchId:
            break
        }
    }

    func createPinComponent(_ createPinComponent: CreatePinComponent, succeedWithPin pin: String) {
        userManager?.save(pin: pin)
        onContinue?()
    }

    func createPinComponentWrongConfirmation(_ createPinComponent: CreatePinComponent) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    @objc
    private func skipButtonTouchEvent(_ sender: UIBarButtonItem) {
        onSkip?()
    }
}
