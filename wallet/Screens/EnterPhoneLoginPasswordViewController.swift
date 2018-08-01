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

    var userManager: WalletUserDefaultsManager?
    var authAPI: AuthAPI?

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

        guard let path = Bundle.main.path(forResource: "PhoneMasks", ofType: "plist"),
            let masks = NSDictionary(contentsOfFile: path) as? [String: [String: String]] else {
                fatalError("PhoneMasks.plist error")
        }

        loginFormView?.providePhoneNumberMasksData(masks)

        let data = AdditionalTextButtonData(textActive: "Forgot password?")

        forgotPasswordButton?.configure(data: data)
        forgotPasswordButton?.addTarget(self, action: #selector(additionalButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        loginFormView?.delegate = self
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func loginFormComponent(_ loginFormComponent: LoginFormComponent, loginingCompleted: Bool) {
        continueButton?.customAppearance.setEnabled(loginingCompleted)
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = loginFormView?.phone,
            let password = loginFormView?.password else {
                return
        }

        continueButton?.customAppearance.setLoading(true)
        authAPI?.signIn(phone: phone, password: password).done {
            [weak self]
            authToken in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.customAppearance.setLoading(false)
                self?.onContinue?(authToken)
            }

            self?.userManager?.save(token: authToken)
            self?.userManager?.save(phoneNumber: phone)


        }.catch {
            [weak self]
            error in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.customAppearance.setLoading(false)
            }

            if let serverError = error as? WalletResponseError {
                switch serverError {
                case .serverFailureResponse(errors: let fails):
                    guard let fail = fails.first else {
                        return
                    }

                    self?.loginFormView?.helperText = fail.message
                }
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: AdditionalTextButton) {
        onRecovery?()
    }
}
