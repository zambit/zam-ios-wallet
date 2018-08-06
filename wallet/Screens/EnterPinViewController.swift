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

    var onContinue: (() -> Void)?
    var onExit: (() -> Void)?

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var dotsFieldComponent: DotsFieldComponent?
    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?

    private var pinText: String = ""

    private var phone: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel?.text = phone

        keyboardComponent?.delegate = self

        setupDefaultStyle()

        walletNavigationController?.addRightBarItemButton(title: "EXIT", target: self, action: #selector(exitButtonTouchEvent(_:)))
    }

    func prepare(phone: String) {
        self.phone = phone
    }

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key) {
        switch key {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            guard let filled = dotsFieldComponent?.fillLast(), filled else {
                return
            }

            pinText.append(key.rawValue)

            if let dotsField = dotsFieldComponent,
                dotsField.filledCount == dotsField.dotsMaxCount {

                switch checkPin(pin: pinText) {
                case true:
                    guard
                        let phone = phone,
                        let password = userManager?.getPassword() else {
                            fatalError()
                    }

                    authAPI?.signIn(phone: phone, password: password).done {
                        [weak self]
                        authToken in

                        if let _ = self?.userManager?.save(token: authToken) {
                            self?.onContinue?()
                        }
                    }.catch {
                        [weak self]
                        error in
                        print(error)
                    }
                case false:
                    dotsFieldComponent?.showFailure {
                        [weak self] in
                        self?.dotsFieldComponent?.unfillAll()
                    }
                }

            }
        case .remove:
            dotsFieldComponent?.unfillLast()
        case .touchId:
            break
        }
    }

    func createPinComponentWrongConfirmation(_ createPinComponent: CreatePinComponent) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    private func checkPin(pin: String) -> Bool {
        guard let savedPin = userManager?.getPin() else {
            fatalError()
        }

        return pin == savedPin
    }

    @objc
    private func exitButtonTouchEvent(_ sender: UIBarButtonItem) {
        userManager?.clearUserData()
        onExit?()
    }
}
