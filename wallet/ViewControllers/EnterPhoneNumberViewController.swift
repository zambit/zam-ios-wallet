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
    @IBOutlet var phoneNumberForm: PhoneNumberFormViewController?
    @IBOutlet var termsStackView: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()

        termsItems = [
            TermItemData(text: "Test for the call to confirm the legal document"),
            TermItemData(text: "Test for the call to confirm the legal document")
        ]

        addSubviews()
        
        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        // Add dictionary with phone codes to appropriate PhoneNumberFormView
        if let path = Bundle.main.path(forResource: "PhoneMasks", ofType: "plist"),
            let masks = NSDictionary(contentsOfFile: path) as? [String: [String: String]] {
            phoneNumberForm?.provideDictionaryOfMasks(masks)
        }
    }

    private func addSubviews() {
        termsItems.forEach {
            let termView = TextCheckBoxView(frame: CGRect.zero)
            termView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
            termView.configure(data: $0)

            termsStackView?.addArrangedSubview(termView)
        }
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        termsStackView?.spacing = 32.0
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = phoneNumberForm?.text else {
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
