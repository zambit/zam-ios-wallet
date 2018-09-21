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
class EnterPhoneNumberViewController: СonsistentViewController, PhoneNumberComponentDelegate {

    var recoveryAPI: RecoveryAPI?

    /**
     Flow parameter for continue action. Needs to provide phone number for doing action
     */
    var onContinue: ((_ phone: String) -> Void)?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberComponent: PhoneNumberComponent?

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
            phoneNumberComponent?.custom.prepare(preset: .superCompact)
        case .medium, .extra, .plus:
            phoneNumberComponent?.custom.prepare(preset: .default)
        case .unknown:
            fatalError()
        }

        setupDefaultStyle()
        
        isKeyboardHidesOnTap = true

        largeTitleLabel?.textColor = .white

        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        phoneNumberComponent?.delegate = self
    }

    // MARK: - PhoneNumberComponentDelegate

    func phoneNumberComponent(_ phoneNumberComponent: PhoneNumberComponent, dontSatisfyTheCondition: PhoneCondition) {
        continueButton?.custom.setEnabled(false)
    }

    func phoneNumberComponentSatisfiesAllConditions(_ phoneNumberComponent: PhoneNumberComponent) {
        continueButton?.custom.setEnabled(true)
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = phoneNumberComponent?.custom.phoneNumber else {
            return
        }

        continueButton?.custom.setLoading(true)
        recoveryAPI?.sendVerificationCode(to: phone).done {
            [weak self] in

            self?.dismissKeyboard {
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

                        self?.phoneNumberComponent?.custom.setHelperText(fail.message.capitalizingFirst)
                    case .undefinedServerFailureResponse:
                        self?.phoneNumberComponent?.custom.setHelperText("Undefined error")
                    }
                }
            }
        }
    }
}
