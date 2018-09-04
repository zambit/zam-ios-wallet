//
//  LoginFormViewController.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol LoginFormComponentDelegate: class {

    func loginFormComponent(_ loginFormComponent: LoginFormComponent, loginingCompleted: Bool)

}

class LoginFormComponent: UIView, PhoneNumberFormComponentDelegate, LoginPasswordComponentDelegate {

    @IBOutlet private var contentView: UIView!

    @IBOutlet private var phoneNumberFormComponent: PhoneNumberFormComponent?
    @IBOutlet private var loginPasswordFormComponent: LoginPasswordFormComponent?

    weak var delegate: LoginFormComponentDelegate?

    var phoneTextFieldHeight: CGFloat {
        get {
            return phoneNumberFormComponent?.textFieldsHeight ?? 0
        }

        set {
            phoneNumberFormComponent?.textFieldsHeight = newValue
            phoneNumberFormComponent?.layoutIfNeeded()
        }
    }

    var passwordTextFieldHeight: CGFloat {
        get {
            return loginPasswordFormComponent?.textFieldHeight ?? 0
        }

        set {
            loginPasswordFormComponent?.textFieldHeight = newValue
            loginPasswordFormComponent?.layoutIfNeeded()
        }
    }

    var phone: String {
        guard let text = phoneNumberFormComponent?.phone else {
            return ""
        }

        return text
    }

    var password: String {
        guard let text = loginPasswordFormComponent?.password else {
            return ""
        }

        return text
    }

    var helperText: String {
        get {
            return loginPasswordFormComponent?.helperText ?? ""
        }

        set {
            loginPasswordFormComponent?.helperText = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        setupStyle()
        configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromNib()
        setupStyle()
        configureSubviews()
    }

    private func initFromNib() {
        Bundle.main.loadNibNamed("LoginFormView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func provide(masks: [String: PhoneMaskData], parser: MaskParser, userCountryCode: String? = nil) {
        phoneNumberFormComponent?.provide(masks: masks, parser: parser, initialCountryCode: userCountryCode)
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureSubviews() {
        phoneNumberFormComponent?.delegate = self
        loginPasswordFormComponent?.delegate = self
    }

    private var phoneNumberCompletionFlag: Bool = false
    private var loginPasswordCompletionFlag: Bool = false

    func phoneNumberFormComponent(_ phoneNumberFormComponent: PhoneNumberFormComponent, dontSatisfyTheCondition: PhoneCondition) {
        phoneNumberCompletionFlag = false
        delegate?.loginFormComponent(self, loginingCompleted: false)
    }

    func phoneNumberFormComponentSatisfiesAllConditions(_ phoneNumberFormComponent: PhoneNumberFormComponent) {
        phoneNumberCompletionFlag = true
        delegate?.loginFormComponent(self, loginingCompleted: loginPasswordCompletionFlag && phoneNumberCompletionFlag)
    }

    func loginPasswordFormComponent(_ loginPasswordFormComponent: LoginPasswordFormComponent, dontSatisfyTheCondition: PasswordsCondition) {
        loginPasswordCompletionFlag = false
        delegate?.loginFormComponent(self, loginingCompleted: false)
    }

    func loginPasswordFormComponentSatisfiesAllConditions(_ loginPasswordFormComponent: LoginPasswordFormComponent) {
        loginPasswordCompletionFlag = true
        delegate?.loginFormComponent(self, loginingCompleted: loginPasswordCompletionFlag && phoneNumberCompletionFlag)
    }

    func loginPasswordFormComponentCanChangeHelperText(_ loginPasswordFormComponent: LoginPasswordFormComponent) -> Bool {
        return false
    }
}
