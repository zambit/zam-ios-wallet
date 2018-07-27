//
//  EnterPhoneNumberViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterPhoneNumberViewController: ContinueViewController {

    var signupAPI: SignupAPI?

    var onContinue: ((_ phone: String) -> Void)?
    var onSkip: (() -> Void)?

    private var termsItems: [TermItemData] = []

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberFormView: PhoneNumberFormView?
    @IBOutlet var termsStackView: UIStackView?

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

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = phoneNumberFormView?.text else {
            return
        }
        print(phone)
        signupAPI?.sendVerificationCode(to: phone).done {
            [weak self] in
            self?.onContinue?(phone)
        }.catch { error in
            print(error)
        }
    }
}

struct TermItemData {
    var text: String
}
