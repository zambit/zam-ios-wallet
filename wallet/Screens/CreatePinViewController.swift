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

    var userManager: UserDataManager?

    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?

    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?
    @IBOutlet var createPinComponent: CreatePinComponent?

    @IBOutlet var verticalBetweenSpacingConstraint: NSLayoutConstraint?

    private var pinText: String = "" {
        didSet {
            print(pinText)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.current.screenType {
        case .small, .extraSmall:
            verticalBetweenSpacingConstraint?.constant = 42.0
        case .medium, .extra, .plus:
            verticalBetweenSpacingConstraint?.constant = 72.0
        case .unknown:
            fatalError()
        }

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
        guard let phone = userManager?.getPhoneNumber() else {
            fatalError()
        }
        do {
            try userManager?.save(pin: pin, for: phone)
        } catch let error {
            fatalError("Error on saving user password \(error)")
        }
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
