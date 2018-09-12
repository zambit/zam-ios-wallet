//
//  CreateNewPasswordViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Creating new password screen controller. Owns its model and views.
 */
class CreateNewPasswordViewController: ContinueViewController, NewPasswordFormComponentDelegate {

    var userManager: UserDefaultsManager?

    var recoveryAPI: RecoveryAPI?
    var signupAPI: SignupAPI?

    /**
     Flow parameter for continue action. Needs to provide authToken for doing action.
     */
    var onContinue: ((String) -> Void)?

    private var phone: String?
    private var token: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var newPasswordFormComponent: NewPasswordFormComponent?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        newPasswordFormComponent?.delegate = self
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func newPasswordFormComponentEditingChange(_ newPasswordFormComponent: NewPasswordFormComponent) {
        // ...
    }

    func newPasswordFormComponent(_ newPasswordFormComponent: NewPasswordFormComponent, dontSatisfyTheCondition: PasswordsCondition) {
        continueButton?.custom.setEnabled(false)
    }

    func newPasswordFormComponentSatisfiesAllConditions(_ newPasswordFormComponent: NewPasswordFormComponent) {
        continueButton?.custom.setEnabled(true)
    }

    /**
     Function for receiveing data from previous ViewController on ScreenFlow
     */
    func prepare(phone: String, token: String) {
        self.phone = phone
        self.token = token
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = self.phone,
            let password = newPasswordFormComponent?.password,
            let confirmation = newPasswordFormComponent?.confirmation,
            let token = self.token else {
            return
        }

        continueButton?.custom.setLoading(true)

        switch (recoveryAPI != nil, signupAPI != nil) {
        case (true, true):
            print("APIs conflict, cant explicity define what API to use")
            break
        case (true, false):
            recoveryAPI?.providePassword(password, confirmation: confirmation, for: phone, recoveryToken: token).done {
                    [weak self] in

                    self?.dismissKeyboard()
                    performWithDelay {
                        self?.continueButton?.custom.setLoading(false)
                        self?.onContinue?(phone)
                    }

                }.catch {
                    [weak self]
                    error in

                    performWithDelay {
                        self?.continueButton?.custom.setLoading(false)
                    }
            }
        case (false, true):
            signupAPI?.providePassword(password, confirmation: confirmation, for: phone, signupToken: token).done {
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
            }
        case (false, false):
            break
        }
    }
}
