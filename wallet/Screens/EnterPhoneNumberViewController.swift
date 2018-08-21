//
//  EnterPhoneNumberViewController.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Entering phone number screen controller. Owns its model and views.
 */
class EnterPhoneNumberViewController: ContinueViewController, PhoneNumberFormComponentDelegate {

    var recoveryAPI: RecoveryAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number for doing action
     */
    var onContinue: ((_ phone: String) -> Void)?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberForm: PhoneNumberFormComponent?

    override func viewDidLoad() {
        super.viewDidLoad()

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

            phoneNumberForm?.provide(masks: masks, parser: MaskParser(symbol: "X", space: " "))
            phoneNumberForm?.delegate = self
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }

    // PhoneNumberFormViewDelegate

    func phoneNumberFormComponent(_ phoneNumberFormComponent: PhoneNumberFormComponent, dontSatisfyTheCondition: PhoneCondition) {
        continueButton?.customAppearance.setEnabled(false)
    }

    func phoneNumberFormComponentSatisfiesAllConditions(_ phoneNumberFormComponent: PhoneNumberFormComponent) {
        continueButton?.customAppearance.setEnabled(true)
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = phoneNumberForm?.phone else {
            return
        }

        continueButton?.customAppearance.setLoading(true)
        recoveryAPI?.sendVerificationCode(to: phone).done {
            [weak self] in

            self?.dismissKeyboard()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.customAppearance.setLoading(false)
                self?.onContinue?(phone)
            }
        }.catch {
            [weak self]
            error in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.continueButton?.customAppearance.setLoading(false)

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
            }
        }
    }
}
