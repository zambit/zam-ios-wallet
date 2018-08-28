//
//  VerifyPhoneNumberWithSmsViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Verifying phone number screen controller. Owns its model and views.
 */
class VerifyPhoneNumberWithSmsViewController: ContinueViewController, VerificationCodeFormComponentDelegate {

    var verifyAPI: ThreeStepsAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number and signUpToken for doing action.
     */
    var onContinue: ((_ phone: String, _ signupToken: String) -> Void)?

    private var phone: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var verificationCodeFormComponent: VerificationCodeFormComponent?
    @IBOutlet var verificationCodeHelperText: UILabel?
    @IBOutlet var sendVerificationCodeAgainButton: AdditionalTextButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        let index = String.Index(encodedOffset: 19)
        let timerParams = AdditionalTextButtonData.TimerParameters(seconds: 60, textInactiveSecondsIndex: index)
        let data = AdditionalTextButtonData(textActive: "Send code again", textInactive: "Send code again in ", timerParams: timerParams)

        sendVerificationCodeAgainButton?.configure(data: data)
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

            self?.dismissKeyboard()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.custom.setLoading(false)
                self?.onContinue?(phone, token)
            }
        }.catch {
            [weak self]
            error in
            print(error)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.custom.setLoading(false)

                if let serverError = error as? WalletResponseError {
                    switch serverError {
                    case .serverFailureResponse(errors: let fails):
                        guard let fail = fails.first else {
                            fatalError()
                        }

                        self?.verificationCodeHelperText?.text = fail.message.capitalizingFirst
                    case .undefinedServerFailureResponse:

                        self?.verificationCodeHelperText?.text = "Undefined error"
                    }
                }
            }
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: AdditionalTextButton) {
        guard let phone = self.phone else {
            return
        }

        sender.custom.setEnabled(false)

        verifyAPI?.sendVerificationCode(to: phone, referrerPhone: nil).done {
            //...
        }.catch { error in
            print(error)
        }
    }

}
