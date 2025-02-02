//
//  EnterPhoneLoginPasswordViewController.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterPhoneLoginPasswordViewController: СonsistentViewController, PhoneNumberComponentDelegate, LoginPasswordComponentDelegate {

    var userManager: UserDefaultsManager?
    var authAPI: AuthAPI?

    var onContinue: ((_ authToken: String) -> Void)?
    var onExit: (() -> Void)?
    var onRecovery: (() -> Void)?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberComponent: PhoneNumberComponent?
    @IBOutlet var loginPasswordFormComponent: LoginPasswordFormComponent?
    @IBOutlet var forgotPasswordButton: TimerButton?

    private var phoneNumberCompletionFlag: Bool = false
    private var loginPasswordCompletionFlag: Bool = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let label = largeTitleLabel {
            largeTitleLabel?.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
            view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIScreen.main.type {
        case .small, .extraSmall:
            phoneNumberComponent?.custom.prepare(preset: .superCompact)
        case .medium, .extra, .extraLarge, .plus:
            phoneNumberComponent?.custom.prepare(preset: .default)
        case .unknown:
            fatalError()
        }

        setupDefaultStyle()
        isKeyboardHidesOnTap = true

        let data = TimerButtonData(textActive: "Forgot password?")
        forgotPasswordButton?.custom.configure(data: data)
        forgotPasswordButton?.addTarget(self, action: #selector(additionalButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        phoneNumberComponent?.delegate = self
        loginPasswordFormComponent?.delegate = self
    }

    // MARK: - PhoneNumberComponentDelegate

    func phoneNumberComponent(_ phoneNumberComponent: PhoneNumberComponent, dontSatisfyTheCondition: Conditions.Phone) {
        phoneNumberCompletionFlag = false
        continueButton?.custom.setEnabled(false)
    }

    func phoneNumberComponentSatisfiesAllConditions(_ phoneNumberComponent: PhoneNumberComponent) {
        phoneNumberCompletionFlag = true
        continueButton?.custom.setEnabled(loginPasswordCompletionFlag && phoneNumberCompletionFlag)
    }

    func phoneNumberComponentCanChangeHelperText(_ phoneNumberComponent: PhoneNumberComponent) -> Bool {
        return false
    }

    // MARK: - LoginPasswordFormComponentDelegate

    func loginPasswordFormComponent(_ loginPasswordFormComponent: LoginPasswordFormComponent, dontSatisfyTheCondition: Conditions.Password) {
        loginPasswordCompletionFlag = false
        continueButton?.custom.setEnabled(false)
    }

    func loginPasswordFormComponentSatisfiesAllConditions(_ loginPasswordFormComponent: LoginPasswordFormComponent) {
        loginPasswordCompletionFlag = true
        continueButton?.custom.setEnabled(loginPasswordCompletionFlag && phoneNumberCompletionFlag)
    }

    func loginPasswordFormComponentCanChangeHelperText(_ loginPasswordFormComponent: LoginPasswordFormComponent) -> Bool {
        return false
    }

    // MARK: - Buttons Touch Events

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = phoneNumberComponent?.custom.phoneNumber,
            let password = loginPasswordFormComponent?.password else {
                return
        }

        continueButton?.custom.setLoading(true)
        authAPI?.signIn(phone: phone, password: password).done {
            [weak self]
            authToken in

            self?.dismissKeyboard {
                self?.continueButton?.custom.setLoading(false)
                self?.onContinue?(authToken)
            }

            self?.userManager?.save(phone: phone, token: authToken)

        }.catch {
            [weak self]
            error in

            performWithDelay {
                self?.continueButton?.custom.setLoading(false)
            }

            if let serverError = error as? WalletResponseError {
                switch serverError {
                case .serverFailureResponse(errors: let fails):
                    self?.loginPasswordFormComponent?.helperText = fails.first?.message.capitalizingFirst ?? ""
                    
                case .undefinedServerFailureResponse:

                    self?.loginPasswordFormComponent?.helperText = "Undefined error"
                }
            } else {
                self?.loginPasswordFormComponent?.helperText = "Connection failed"
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: TimerButton) {
        dismissKeyboard {
            [weak self] in

            self?.onRecovery?()
        }
    }
}
