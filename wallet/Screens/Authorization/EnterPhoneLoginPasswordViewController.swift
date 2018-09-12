//
//  EnterPhoneLoginPasswordViewController.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterPhoneLoginPasswordViewController: ContinueViewController, LoginFormComponentDelegate {

    var userManager: UserDefaultsManager?
    var authAPI: AuthAPI?
    var telephonyProvider: UserTelephonyInfoProvider?

    var onContinue: ((_ authToken: String) -> Void)?
    var onExit: (() -> Void)?
    var onRecovery: (() -> Void)?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var loginFormView: LoginFormComponent?
    @IBOutlet var forgotPasswordButton: AdditionalTextButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        let data = AdditionalTextButtonData(textActive: "Forgot password?")

        forgotPasswordButton?.configure(data: data)
        forgotPasswordButton?.addTarget(self, action: #selector(additionalButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        // Add dictionary with phone codes to appropriate PhoneNumberFormView
        guard let path = Bundle.main.path(forResource: "PhoneMasks", ofType: "plist"),
            let masksDictionary = NSDictionary(contentsOfFile: path) as? [String: [String: String]] else {
                fatalError("PhoneMasks.plist error")
        }

        // Convert dictionary of mask to appropriate format
        do {
            let masks = try masksDictionary.mapValues {
                return try PhoneMaskData(dictionary: $0)
            }

            loginFormView?.delegate = self
            loginFormView?.provide(masks: masks, parser: MaskParser(symbol: "X", space: " "), userCountryCode: telephonyProvider?.countryCode)
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func loginFormComponent(_ loginFormComponent: LoginFormComponent, loginingCompleted: Bool) {
        continueButton?.custom.setEnabled(loginingCompleted)
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = loginFormView?.phone,
            let password = loginFormView?.password else {
                return
        }

        continueButton?.custom.setLoading(true)
        authAPI?.signIn(phone: phone, password: password).done {
            [weak self]
            authToken in

            self?.dismissKeyboard()

            performWithDelay {
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
                    guard let fail = fails.first else {
                        fatalError()
                    }

                    self?.loginFormView?.helperText = fail.message.capitalizingFirst
                case .undefinedServerFailureResponse:

                    self?.loginFormView?.helperText = "Undefined error"
                }
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: AdditionalTextButton) {
        onRecovery?()
    }
}
