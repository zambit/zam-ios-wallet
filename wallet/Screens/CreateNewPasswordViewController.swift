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
class CreateNewPasswordViewController: ContinueViewController, NewPasswordFormViewDelegate {

    var userManager: WalletUserDefaultsManager?
    var signupAPI: SignupAPI?

    /**
     Flow parameter for continue action. Needs to provide authToken for doing action.
     */
    var onContinue: ((_ authToken: String) -> Void)?

    private var phone: String?
    private var signupToken: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var newPasswordFormView: NewPasswordFormViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        newPasswordFormView?.delegate = self
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func newPasswordFormViewControllerEditingChange(_ newPasswordFormViewController: NewPasswordFormViewController) {
        // ...
    }

    func newPasswordFormViewController(_ newPasswordFormView: NewPasswordFormViewController, dontSatisfyTheCondition: PasswordsCondition) {
        // show error
        continueButton?.customAppearance.setEnabled(false)
    }

    func newPasswordFormViewControllerSatisfiesAllConditions(_ newPasswordFormView: NewPasswordFormViewController) {
        continueButton?.customAppearance.setEnabled(true)
    }

    /**
     Function for receiveing data from previous ViewController on ScreenFlow
     */
    func prepare(phone: String, signupToken: String) {
        self.phone = phone
        self.signupToken = signupToken
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = self.phone,
            let password = newPasswordFormView?.password,
            let confirmation = newPasswordFormView?.confirmation,
            let token = self.signupToken else {
            return
        }

        signupAPI?.providePassword(password, confirmation: confirmation, for: phone, signUpToken: token).done {
            [weak self]
            authToken in

            self?.userManager?.save(token: authToken)
            self?.userManager?.save(phoneNumber: phone)

            self?.onContinue?(authToken)

            print(authToken)
        }.catch { error in
            print(error)
        }
    }
}
