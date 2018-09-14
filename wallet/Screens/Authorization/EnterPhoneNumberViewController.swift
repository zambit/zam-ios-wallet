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

    var telephonyProvider: UserTelephonyInfoProvider?
    var recoveryAPI: RecoveryAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number for doing action
     */
    var onContinue: ((_ phone: String) -> Void)?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberForm: PhoneNumberFormComponent?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let label = largeTitleLabel {
            largeTitleLabel?.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
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

    func phoneNumberFormComponent(_ phoneNumberFormComponent: PhoneNumberFormComponent, dontSatisfyTheCondition: PhoneCondition) {
        continueButton?.custom.setEnabled(false)
    }

    func phoneNumberFormComponentSatisfiesAllConditions(_ phoneNumberFormComponent: PhoneNumberFormComponent) {
        continueButton?.custom.setEnabled(true)
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

        continueButton?.custom.setLoading(true)
        recoveryAPI?.sendVerificationCode(to: phone).done {
            [weak self] in

            self?.dismissKeyboard()

            performWithDelay {
                self?.continueButton?.custom.setLoading(false)
                self?.onContinue?(phone)
            }
        }.catch {
            [weak self]
            error in

            performWithDelay {
                self?.continueButton?.custom.setLoading(false)

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
