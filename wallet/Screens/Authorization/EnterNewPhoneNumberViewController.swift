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

    var telephonyProvider: UserTelephonyInfoProvider?
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
    @IBOutlet var phoneNumberForm: PhoneNumberFormComponent?
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
            phoneNumberForm?.prepare(preset: .superCompact)
        case .medium, .extra, .plus:
            phoneNumberForm?.prepare(preset: .default)
        case .unknown:
            fatalError()
        }

        termsItems = [
            TermData(text: "I accept the Terms of Use and give my consent to Zamzam LLC to process my personal data for the services outlined in the Privacy Policy")
        ]

        addSubviews()
        
        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()

        // Add dictionary with phone codes to appropriate PhoneNumberFormView
        guard let path = Bundle.main.path(forResource: "PhoneMasks", ofType: "plist"),
            let masksDictionary = NSDictionary(contentsOfFile: path) as? [String: [String: String]] else {
                fatalError("PhoneMasks.plist error")
        }

        // Convert dictionary of mask to appropriate format
        do {
            let masks = try masksDictionary.mapValues {
                return try PhoneMaskData(dictionary: $0)
            }

            phoneNumberForm?.delegate = self
            phoneNumberForm?.provide(masks: masks, parser: MaskParser(symbol: "X", space: " "), initialCountryCode: telephonyProvider?.countryCode)

        } catch let e {
            fatalError(e.localizedDescription)
        }
    }

    // PhoneNumberFormViewDelegate

    func phoneNumberFormComponent(_ phoneNumberFormViewController: PhoneNumberFormComponent, dontSatisfyTheCondition: PhoneCondition) {
        phoneNumberValid = false
        continueButton?.custom.setEnabled(false)
    }

    func phoneNumberFormComponentSatisfiesAllConditions(_ phoneNumberFormViewController: PhoneNumberFormComponent) {
        phoneNumberValid = true
        continueButton?.custom.setEnabled(phoneNumberValid && allTermsAccepted)
    }

    private func addSubviews() {
        termsItems.forEach {
            let termView = TextCheckBoxView(frame: CGRect.zero)
            //termView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
            termView.configure(text: $0.text)
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

        continueButton?.custom.setLoading(true)
        signupAPI?.sendVerificationCode(to: phone).done {
            [weak self] in

            self?.dismissKeyboard()

            performWithDelay {
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

                    self?.phoneNumberForm?.helperText = fail.message.capitalizingFirst
                case .undefinedServerFailureResponse:

                    self?.phoneNumberForm?.helperText = "Undefined error"
                }
            }

            performWithDelay {
                self?.continueButton?.custom.setLoading(false)
            }
        }
    }
}
