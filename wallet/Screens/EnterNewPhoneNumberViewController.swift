//
//  EnterPhoneNumberViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Entering new phone number screen controller. Owns its model and views.
 */
class EnterNewPhoneNumberViewController: ContinueViewController, PhoneNumberFormComponentDelegate {

    var signupAPI: SignupAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number for doing action
     */
    var onContinue: ((_ phone: String) -> Void)?
    
    /**
     Flow parameter for skip action
     */
    var onSkip: (() -> Void)?

    private var termsItems: [TermItemData] = []

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberForm: PhoneNumberFormComponent?
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
        guard let path = Bundle.main.path(forResource: "PhoneMasks", ofType: "plist"),
            let masks = NSDictionary(contentsOfFile: path) as? [String: [String: String]] else {
                fatalError("PhoneMasks.plist error")
        }

        phoneNumberForm?.provideDictionaryOfMasks(masks)
        phoneNumberForm?.delegate = self
    }

    // PhoneNumberFormViewDelegate

    func phoneNumberFormComponent(_ phoneNumberFormViewController: PhoneNumberFormComponent, dontSatisfyTheCondition: PhoneCondition) {
        continueButton?.customAppearance.setEnabled(false)
    }

    func phoneNumberFormComponentSatisfiesAllConditions(_ phoneNumberFormViewController: PhoneNumberFormComponent) {
        continueButton?.customAppearance.setEnabled(true)
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
        guard let phone = phoneNumberForm?.phone else {
            return
        }

        continueButton?.customAppearance.setLoading(true)
        signupAPI?.sendVerificationCode(to: phone).done {
            [weak self] in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.customAppearance.setLoading(false)
                self?.onContinue?(phone)
            }
        }.catch {
            [weak self]
            error in

            if let serverError = error as? WalletResponseError {
                switch serverError {
                case .serverFailureResponse(errors: let fails):
                    guard let fail = fails.first else {
                        return
                    }

                    self?.phoneNumberForm?.helperText = fail.message
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.customAppearance.setLoading(false)
            }
        }
    }
}

/**
 Struct represents all properties needed to fill TermItem.
 */
struct TermItemData {
    var text: String
}
