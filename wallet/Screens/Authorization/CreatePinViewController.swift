//
//  CreatePinViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class CreatePinViewController: FlowViewController, WalletNavigable, DecimalKeyboardComponentDelegate, CreatePinComponentDelegate {

    var userManager: UserDefaultsManager?

    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?

    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?
    @IBOutlet var createPinComponent: CreatePinComponent?

    @IBOutlet var topConstraint: NSLayoutConstraint?
    @IBOutlet var verticalBetweenSpacingConstraint: NSLayoutConstraint?

    private var pinText: String = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        migratingNavigationController?.custom.addRightBarItemButton(for: self, title: "SKIP", target: self, action: #selector(skipButtonTouchEvent(_:)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIScreen.main.type {
        case .small, .extraSmall:
            verticalBetweenSpacingConstraint?.constant = 42.0
            topConstraint?.constant = 150
        case .medium:
            verticalBetweenSpacingConstraint?.constant = 72.0
            topConstraint?.constant = 200
        case .extra, .plus:
            verticalBetweenSpacingConstraint?.constant = 72.0
            topConstraint?.constant = 266
        case .extraLarge:
            verticalBetweenSpacingConstraint?.constant = 72.0
            topConstraint?.constant = 320
        case .unknown:
            fatalError()
        }

        keyboardComponent?.delegate = self
        createPinComponent?.delegate = self

        setupDefaultStyle()
    }

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key) {
        switch key {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            createPinComponent?.enterTheKey(key.rawValue)
        case .remove:
            createPinComponent?.removeLast()
        case .touchId:
            break
        case .faceId:
            break
        case .empty:
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

        createPinComponent.beginDotsLoading()

        performWithDelay {
            [weak self] in

            UserContactsManager.default.fetchContacts({ _ in
                createPinComponent.endDotsLoading()
                self?.onContinue?()
            })
        }
    }

    func createPinComponentWrongConfirmation(_ createPinComponent: CreatePinComponent) {
        Interactions.vibrateError()
    }

    @objc
    private func skipButtonTouchEvent(_ sender: UIBarButtonItem) {
        createPinComponent?.beginDotsLoading()

        performWithDelay {
            [weak self] in

            UserContactsManager.default.fetchContacts({ _ in
                self?.createPinComponent?.endDotsLoading()
                self?.onSkip?()
            })
        }
    }
}
