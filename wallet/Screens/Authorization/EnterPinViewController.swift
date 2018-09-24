//
//  EnterPinViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class EnterPinViewController: FlowViewController, WalletNavigable, DecimalKeyboardComponentDelegate {

    var userManager: UserDefaultsManager?
    var authAPI: AuthAPI?
    var biometricAuth: BiometricIDAuth?

    var onContinue: (() -> Void)?
    var onExit: (() -> Void)?
    var onLoginForm: ((_ phone: String) -> Void)?

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var dotsFieldComponent: DotsFieldComponent?
    @IBOutlet var keyboardComponent: DecimalKeyboardComponent?

    @IBOutlet var topConstraint: NSLayoutConstraint?
    @IBOutlet var verticalBetweenSpacingConstraint: NSLayoutConstraint?

    private var pinText: String = ""

    private var phone: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        migratingNavigationController?.custom.addRightBarItemButton(for: self, title: "EXIT", target: self, action: #selector(exitButtonTouchEvent(_:)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        biometricAuthenticationRequest()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIScreen.main.type {
        case .extraSmall, .small:
            verticalBetweenSpacingConstraint?.constant = 42
            topConstraint?.constant = 150
        case .medium:
            verticalBetweenSpacingConstraint?.constant = 72
            topConstraint?.constant = 200
        case .plus, .extra:
            verticalBetweenSpacingConstraint?.constant = 72
            topConstraint?.constant = 266
        case .extraLarge:
            verticalBetweenSpacingConstraint?.constant = 92
            topConstraint?.constant = 340
        case .unknown:
            fatalError()
        }

        if let biometric = biometricAuth {
            switch biometric.biometricType() {
            case .faceID:
                keyboardComponent?.setDetailButtonKey(.faceId)
            case .touchID:
                keyboardComponent?.setDetailButtonKey(.touchId)
            case .none:
                break
            }
        }

        titleLabel?.text = phone

        keyboardComponent?.delegate = self

        setupDefaultStyle()
    }

    func prepare(phone: String) {
        self.phone = phone
    }

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key) {
        switch key {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            guard let filled = dotsFieldComponent?.fillLast(), filled else {
                return
            }

            pinText.append(key.rawValue)

            if let dotsField = dotsFieldComponent,
                dotsField.filledCount == dotsField.dotsMaxCount {

                switch checkPin(pinText) {
                case true:
                    dotsFieldComponent?.fillAll()
                    dotsFieldComponent?.fillingEnabled = false

                    guard let token = userManager?.getToken() else {
                        return
                    }

                    dotsFieldComponent?.beginLoading()

                    authAPI?.checkIfUserAuthorized(token: token).done {
                        [weak self]
                        phone in

                        self?.authAPI?.refreshToken(token: token).done {
                            token in

                            self?.userManager?.save(token: token)

                            performWithDelay {
                                UserContactsManager.default.fetchContacts({ _ in
                                    self?.dotsFieldComponent?.endLoading()
                                    self?.onContinue?()
                                })
                            }
                        }.catch {
                            error in

                            performWithDelay {
                                self?.dotsFieldComponent?.endLoading()
                                self?.onLoginForm?(phone)
                            }

                        }
                    }.catch {
                        [weak self]
                        error in

                        guard let strongSelf = self else {
                            return
                        }

                        guard let phone = strongSelf.phone else {
                            fatalError("Error on catching checkingIfUserAuthorized")
                        }

                        performWithDelay {
                            self?.dotsFieldComponent?.endLoading()
                            self?.onLoginForm?(phone)
                        }
                    }
                case false:
                    dotsFieldComponent?.endLoading()
                    dotsFieldComponent?.fillingEnabled = false
                    dotsFieldComponent?.showFailure {
                        [weak self] in
                        self?.dotsFieldComponent?.unfillAll()
                        self?.dotsFieldComponent?.fillingEnabled = true
                    }

                    pinText = ""
                    Interactions.vibrateError()
                }

            }
        case .remove:
            dotsFieldComponent?.unfillLast()
            if !pinText.isEmpty {
                pinText.removeLast()
            }
        case .touchId, .faceId:
            biometricAuthenticationRequest()
        case .empty:
            break
        }
    }

    private func checkPin(_ pin: String) -> Bool {
        do {
            let saved = try userManager?.getPin()

            if let savedPin = saved {
                return pin == savedPin
            }
        } catch let error {
            fatalError("Error on receiving saved pin: \(error)")
        }

        return false
    }

    private func biometricAuthenticationRequest() {
        biometricAuth?.authenticateUser(reason: "Please use your fingerprint to sign in", success: {
            [weak self] in

            self?.dotsFieldComponent?.fillAll()

            guard let token = self?.userManager?.getToken() else {
                return
            }

            self?.dotsFieldComponent?.beginLoading()

            self?.authAPI?.checkIfUserAuthorized(token: token).done {
                phone in

                self?.authAPI?.refreshToken(token: token).done {
                    token in

                    self?.userManager?.save(token: token)

                    performWithDelay {
                        UserContactsManager.default.fetchContacts({ _ in
                            self?.dotsFieldComponent?.endLoading()
                            self?.onContinue?()
                        })
                    }
                }.catch {
                    error in

                    performWithDelay {
                        self?.dotsFieldComponent?.endLoading()
                        self?.onLoginForm?(phone)
                    }

                }
            }.catch {
                [weak self]
                error in

                guard let strongSelf = self else {
                    return
                }

                guard let phone = strongSelf.phone else {
                    fatalError("Error on catching checkingIfUserAuthorized")
                }

                strongSelf.userManager?.clearToken()

                performWithDelay {
                    self?.dotsFieldComponent?.endLoading()
                    self?.onLoginForm?(phone)
                }
            }
        }, failure: {
            [weak self]
            error in

            switch error {
            case .userCancelBiometricAuthentication:
                break
            case .biometricAuthenticationError:
                self?.keyboardComponent?.detailButton?.isEnabled = false
            }
        })
    }

    @objc
    private func exitButtonTouchEvent(_ sender: UIBarButtonItem) {
        do {
            if let token = userManager?.getToken() {
                authAPI?.signOut(token: token)
            }

            try userManager?.clearUserData()
        } catch let error {
            fatalError("Error on clearing user data: \(error)")
        }
        onExit?()
    }
}
