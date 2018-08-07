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

    var userManager: UserDataManager?

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
        continueButton?.customAppearance.setEnabled(false)
    }

    func newPasswordFormComponentSatisfiesAllConditions(_ newPasswordFormComponent: NewPasswordFormComponent) {
        continueButton?.customAppearance.setEnabled(true)
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

        continueButton?.customAppearance.setLoading(true)

        switch (recoveryAPI != nil, signupAPI != nil) {
        case (true, true):
            print("APIs conflict, cant explicity define what API to use")
            break
        case (true, false):
            recoveryAPI?.providePassword(password, confirmation: confirmation, for: phone, recoveryToken: token).done {
                    [weak self] in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.continueButton?.customAppearance.setLoading(false)
                        self?.onContinue?(phone)
                    }

//                    do {
//                        try self?.userManager?.save(phone: phone, password: password)
//                    } catch let error {
//                        fatalError("Error on saving user password \(error)")
//                    }
                }.catch {
                    [weak self]
                    error in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.continueButton?.customAppearance.setLoading(false)
                    }
            }
        case (false, true):
            signupAPI?.providePassword(password, confirmation: confirmation, for: phone, signupToken: token).done {
                    [weak self]
                    authToken in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.continueButton?.customAppearance.setLoading(false)
                        self?.onContinue?(authToken)
                    }

                    self?.userManager?.save(phone: phone, token: token)

//                    do {
//                        try self?.userManager?.save(phone: phone, password: password, token: token)
//                    } catch let error {
//                        fatalError("Error on saving user password \(error)")
//                    }
                }.catch {
                    [weak self]
                    error in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.continueButton?.customAppearance.setLoading(false)
                    }
            }
        case (false, false):
            break
        }
    }
}
