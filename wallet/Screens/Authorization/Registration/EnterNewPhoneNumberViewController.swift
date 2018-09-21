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
class EnterNewPhoneNumberViewController: СonsistentViewController, PhoneNumberComponentDelegate {

    var signupAPI: SignupAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number for doing action
     */
    var onContinue: ((_ phone: String) -> Void)?
    
    /**
     Flow parameter for skip action
     */
    var onSkip: (() -> Void)?

    private var termsItems: [TermData] = []

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberComponent: PhoneNumberComponent?
    @IBOutlet var termsStackView: UIStackView?

    private var phoneNumberValid: Bool = false
    private var allTermsAccepted: Bool {
        guard let views = termsStackView?.arrangedSubviews else {
            return true
        }

        let checkBoxes = views.compactMap { return $0 as? TextCheckBoxView }

        return !checkBoxes.contains { $0.isChecked == false }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let label = largeTitleLabel, let stack = termsStackView {
            largeTitleLabel?.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
            termsStackView?.heightAnchor.constraint(equalToConstant: stack.bounds.height).isActive = true

            view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.current.screenType {
        case .small, .extraSmall:
            phoneNumberComponent?.custom.prepare(preset: .superCompact)
        case .medium, .extra, .plus, .extraLarge:
            phoneNumberComponent?.custom.prepare(preset: .default)
        case .unknown:
            fatalError()
        }

        termsItems = [
            TermData(text: "I accept the Terms of Use and give my consent to ZamZamTechnology OÜ to process my personal data for the services outlined in the Privacy Policy", linkText: ["Terms of Use", "Privacy Policy"])
        ]
        setupTermsItems()

        setupDefaultStyle()
        isKeyboardHidesOnTap = true

        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        termsStackView?.spacing = 32.0

        phoneNumberComponent?.delegate = self
    }

    // PhoneNumberComponentDelegate

    func phoneNumberComponent(_ phoneNumberComponent: PhoneNumberComponent, dontSatisfyTheCondition: PhoneCondition) {
        phoneNumberValid = false
        continueButton?.custom.setEnabled(false)
    }

    func phoneNumberComponentSatisfiesAllConditions(_ phoneNumberComponent: PhoneNumberComponent) {
        phoneNumberValid = true
        continueButton?.custom.setEnabled(phoneNumberValid && allTermsAccepted)
    }

    private func setupTermsItems() {
        termsItems.forEach {
            let termView = TextCheckBoxView(frame: CGRect.zero)

            termView.configure(text: $0.text, tapableText: $0.linkText, tapHandler: { element in
                switch element {
                case "Terms of Use":
                    UIApplication.shared.open(ExternalLinks.terms.url)
                case "Privacy Policy":
                    UIApplication.shared.open(ExternalLinks.privacy.url)
                default:
                    return
                }
            })
            termView.sizeToFit()
            termView.addAction({
                [weak self]
                _ in

                guard let strongSelf = self else {
                    return
                }
                strongSelf.continueButton?.custom.setEnabled(strongSelf.phoneNumberValid && strongSelf.allTermsAccepted)
            }, for: .check)

            termsStackView?.addArrangedSubview(termView)
        }
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = phoneNumberComponent?.custom.phoneNumber else {
            return
        }

        continueButton?.custom.setLoading(true)
        signupAPI?.sendVerificationCode(to: phone).done {
            [weak self] in

            self?.dismissKeyboard {
                self?.continueButton?.custom.setLoading(false)
                self?.onContinue?(phone)
            }
        }.catch {
            [weak self]
            error in

            if let serverError = error as? WalletResponseError {
                switch serverError {
                case .serverFailureResponse(errors: let fails):
                    guard let fail = fails.first else {
                        fatalError()
                    }

                    self?.phoneNumberComponent?.custom.setHelperText(fail.message.capitalizingFirst)
                case .undefinedServerFailureResponse:

                    self?.phoneNumberComponent?.custom.setHelperText("Undefined error")
                }
            }

            performWithDelay {
                self?.continueButton?.custom.setLoading(false)
            }
        }
    }
}
