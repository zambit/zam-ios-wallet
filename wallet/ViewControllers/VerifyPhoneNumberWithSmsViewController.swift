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
class VerifyPhoneNumberWithSmsViewController: ContinueViewController, VerificationCodeFormViewDelegate {

    var signupAPI: SignupAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number and signUpToken for doing action.
     */
    var onContinue: ((_ phone: String, _ signupToken: String) -> Void)?

    private var phone: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var verificationCodeFormView: VerificationCodeFormViewController?
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

        verificationCodeFormView?.delegate = self
    }

    func verificationCodeFormViewController(_ verificationCodeFormViewController: VerificationCodeFormViewController, codeEnteringIsCompleted: Bool) {
        continueButton?.customAppearance.setEnabled(codeEnteringIsCompleted)
    }

    /**
     Function for receiveing data from previous ViewController on ScreenFlow
     */
    func prepare(phone: String) {
        self.phone = phone
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = self.phone, let code = verificationCodeFormView?.text else {
            return
        }

        signupAPI?.verifyUserAccount(passing: code, hasBeenSentTo: phone).done {
            [weak self]
            token in

            self?.onContinue?(phone, token)
        }.catch { error in
            print(error)
        }
    }

    @objc
    private func additionalButtonTouchUpInsideEvent(_ sender: AdditionalTextButton) {
        guard let phone = self.phone else {
            return
        }

        sender.customAppearance.setEnabled(false)

        signupAPI?.sendVerificationCode(to: phone).done {
            //
        }.catch { error in
            print(error)
        }
    }

}
