//
//  EnterLoginPasswordViewController.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterLoginPasswordViewController: ContinueViewController, LoginPasswordComponentDelegate {

    var userManager: WalletUserDefaultsManager?
    var authAPI: AuthAPI?

    var onContinue: ((_ authToken: String) -> Void)?
    var onExit: (() -> Void)?
    var onRecovery: ((_ phone: String) -> Void)?

    private var phone: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var loginPasswordForm: LoginPasswordFormComponent?
    @IBOutlet var forgotPasswordButton: AdditionalTextButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        let data = AdditionalTextButtonData(textActive: "Forgot password?")

        forgotPasswordButton?.configure(data: data)
        forgotPasswordButton?.addTarget(self, action: #selector(additionalButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        loginPasswordForm?.delegate = self

//        if let maskData = userManager?.getMaskData(), let phone = phone {
//            title = MaskParser(symbol: maskData.1, space: maskData.2).matchingUnstrict(text: phone, withMask: maskData.0)
//        }

        walletNavigationController?.addRightBarItemButton(title: "EXIT", target: self, action: #selector(exitButtonTouchEvent(_:)))
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func loginPasswordFormComponent(_ loginPasswordFormView: LoginPasswordFormComponent, dontSatisfyTheCondition: PasswordsCondition) {
        continueButton?.customAppearance.setEnabled(false)
    }

    func loginPasswordFormComponentSatisfiesAllConditions(_ loginPasswordFormViewController: LoginPasswordFormComponent) {
        continueButton?.customAppearance.setEnabled(true)
    }

    /**
     Function for receiveing data from previous ViewController on ScreenFlow
     */
    func prepare(phone: String) {
        self.phone = phone
        print("Phone: \(phone)")
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = self.phone,
            let password = loginPasswordForm?.password else {
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

                    self?.loginPasswordForm?.helperText = fail.message
                }
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: AdditionalTextButton) {
        guard let phone = self.phone else {
            return
        }

        onRecovery?(phone)
    }

    @objc
    private func exitButtonTouchEvent(_ sender: UIBarButtonItem) {
        guard let token = userManager?.getToken() else {
            userManager?.clearUserData()
            onExit?()
            return
        }

        continueButton?.customAppearance.setLoading(true)

        authAPI?.signOut(token: token).done {
            [weak self] in

            self?.userManager?.clearUserData()
            self?.onExit?()
            
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

                    self?.loginPasswordForm?.helperText = fail.message
                }
            }
        }

    }
}


