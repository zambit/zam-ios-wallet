//
//  VerifyPhoneNumberWithSmsViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class VerifyPhoneNumberWithSmsViewController: ContinueViewController {

    var signupAPI: SignupAPI?

    var onContinue: ((String, String) -> Void)?

    private var phone: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var verificationCodeFormView: VerificationCodeFormView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()
    }

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

}
