//
//  EnterLoginPasswordViewController.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterLoginPasswordViewController: СonsistentViewController, LoginPasswordComponentDelegate {

    var userManager: UserDefaultsManager?
    var authAPI: AuthAPI?

    var onContinue: ((_ authToken: String) -> Void)?
    var onExit: (() -> Void)?
    var onRecovery: ((_ phone: String) -> Void)?

    private var phone: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var loginPasswordForm: LoginPasswordFormComponent?
    @IBOutlet var forgotPasswordButton: TimerButton?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        walletNavigationController?.custom.addRightDetailButton(in: self, title: "EXIT", target: self, action: #selector(exitButtonTouchEvent(_:)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let label = largeTitleLabel {
            largeTitleLabel?.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
            view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        isKeyboardHidesOnTap = true

        setupDefaultStyle()
        setupViewControllerStyle()

        let data = TimerButtonData(textActive: "Forgot password?")

        forgotPasswordButton?.custom.configure(data: data)
        forgotPasswordButton?.addTarget(self, action: #selector(additionalButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        loginPasswordForm?.delegate = self
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func loginPasswordFormComponent(_ loginPasswordFormView: LoginPasswordFormComponent, dontSatisfyTheCondition: Conditions.Password) {
        continueButton?.custom.setEnabled(false)
    }

    func loginPasswordFormComponentSatisfiesAllConditions(_ loginPasswordFormViewController: LoginPasswordFormComponent) {
        continueButton?.custom.setEnabled(true)
    }

    /**
     Function for receiveing data from previous ViewController on ScreenFlow
     */
    func prepare(phone: String) {
        self.phone = phone
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = self.phone,
            let password = loginPasswordForm?.password else {
                return
        }

        continueButton?.custom.setLoading(true)
        authAPI?.signIn(phone: phone, password: password).done {
            [weak self]
            authToken in

            self?.dismissKeyboard {
                UserContactsManager.default.fetchContacts({ _ in
                    self?.continueButton?.custom.setLoading(false)
                    self?.onContinue?(authToken)
                })
            }

            self?.userManager?.clearToken()
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
                    self?.loginPasswordForm?.helperText = fails.first?.message.capitalizingFirst ?? ""

                case .undefinedServerFailureResponse:
                    self?.loginPasswordForm?.helperText = "Undefined error"
                }
            } else {
                self?.loginPasswordForm?.helperText = "Connection failed"
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: TimerButton) {
        guard let phone = self.phone else {
            return
        }

        dismissKeyboard {
            [weak self] in
            
            self?.onRecovery?(phone)
        }
    }

    @objc
    private func exitButtonTouchEvent(_ sender: UIBarButtonItem) {
        let exit: () -> Void = {
            [weak self] in

            do {
                try self?.userManager?.clearUserData()
            } catch let error {
                fatalError("Error on clearing user data: \(error)")
            }

            self?.dismissKeyboard {
                self?.continueButton?.custom.setLoading(false)
                self?.onExit?()
            }
        }

        guard let token = userManager?.getToken() else {
            exit()
            return
        }

        continueButton?.custom.setLoading(true)

        authAPI?.signOut(token: token).done {
            exit()
        }.catch {
            [weak self]
            error in

            if let _ = error as? WalletResponseError {
                exit()
            } else {
                self?.loginPasswordForm?.helperText = "Connection failed"
            }
        }

    }
}


