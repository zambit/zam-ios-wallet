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
class CreateNewPasswordViewController: ContinueViewController {

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
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
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

            print(authToken)
        }.catch { error in
            print(error)
        }
    }
}
