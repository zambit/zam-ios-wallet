//
//  VerifyPhoneNumberWithSmsViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

/**
 Verifying phone number screen controller. Owns its model and views.
 */
class VerifyPhoneNumberWithSmsViewController: СonsistentViewController, VerificationCodeFormComponentDelegate {

    var verifyAPI: CreatePasswordProcess?

    /**
     Flow parameter for continue action. Needs to provide phone number and signUpToken for doing action.
     */
    var onContinue: ((_ phone: String, _ signupToken: String) -> Void)?

    private var phone: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var verificationCodeFormComponent: VerificationCodeFormComponent?
    @IBOutlet var verificationCodeHelperText: UILabel?
    @IBOutlet var sendVerificationCodeAgainButton: TimerButton?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let label = largeTitleLabel {
            largeTitleLabel?.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
            view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        
        isKeyboardHidesOnTap = true

        setupViewControllerStyle()

        let index = String.Index(encodedOffset: 19)
        let timerParams = TimerButtonData.TimerParameters(seconds: 60, textInactiveSecondsIndex: index)
        let data = TimerButtonData(textActive: "Send code again", textInactive: "Send code again in ", timerParams: timerParams)

        sendVerificationCodeAgainButton?.custom.configure(data: data)
        sendVerificationCodeAgainButton?.addTarget(self, action: #selector(additionalButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        verificationCodeFormComponent?.delegate = self
    }

    func verificationCodeFormComponent(_ verificationCodeFormViewController: VerificationCodeFormComponent, codeEnteringIsCompleted: Bool) {
        continueButton?.custom.setEnabled(codeEnteringIsCompleted)
    }

    /**
     Function for receiveing data from previous ViewController on ScreenFlow
     */
    func prepare(phone: String) {
        self.phone = phone
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        verificationCodeHelperText?.textColor = .error
        verificationCodeHelperText?.text = ""

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = self.phone, let code = verificationCodeFormComponent?.text else {
            return
        }

        continueButton?.custom.setLoading(true)
        verifyAPI?.verifyPhoneNumber(phone, withCode: code).done {
            [weak self]
            token in

            self?.dismissKeyboard {
                self?.continueButton?.custom.setLoading(false)
                self?.onContinue?(phone, token)
            }
        }.catch {
            [weak self]
            error in

            performWithDelay {
                self?.continueButton?.custom.setLoading(false)

                if let serverError = error as? WalletResponseError {
                    switch serverError {
                    case .serverFailureResponse(errors: let fails):
                        self?.verificationCodeHelperText?.text = fails.first?.message.capitalizingFirst ?? ""

                    case .undefinedServerFailureResponse:
                        self?.verificationCodeHelperText?.text = "Undefined error"
                        
                    }
                } else {
                    self?.verificationCodeHelperText?.text = "Connection failed"
                }
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: TimerButton) {
        guard let phone = self.phone else {
            return
        }

        sender.custom.setEnabled(false)

        verifyAPI?.sendVerificationCode(to: phone, referrerPhone: nil).done {
            //...
        }.catch {
            error in

            Crashlytics.sharedInstance().recordError(error)
        }
    }
}
