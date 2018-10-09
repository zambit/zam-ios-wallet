//
//  NewPasswordFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol NewPasswordFormComponentDelegate: class {

    func newPasswordFormComponentEditingChange(_ newPasswordFormComponent: NewPasswordFormComponent)

    func newPasswordFormComponent(_ newPasswordFormComponent: NewPasswordFormComponent, dontSatisfyTheCondition: Conditions.Password)

    func newPasswordFormComponentSatisfiesAllConditions(_ newPasswordFormComponent: NewPasswordFormComponent)

}

class NewPasswordFormComponent: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var passwordTextField: UITextField?
    @IBOutlet private var passwordConfirmationTextField: UITextField?
    @IBOutlet private var helperTextLabel: UILabel?

    @IBOutlet private var passwordTextFieldHeightConstraint: NSLayoutConstraint?

    /**
     Timer for performing helperText changing with some delay
     */
    private var helperTextDelayTimer: DelayTimer?
    private var helperTextDelayValue: Double = 1.0

    weak var delegate: NewPasswordFormComponentDelegate?

    var textFieldsHeight: CGFloat {
        get {
            return passwordTextFieldHeightConstraint?.constant ?? 0
        }

        set {
            passwordTextFieldHeightConstraint?.constant = newValue
        }
    }

    var helperText: String {
        get {
            return helperTextLabel?.text ?? ""
        }

        set {
            helperTextLabel?.text = newValue
        }
    }


    var password: String {
        guard let text = passwordTextField?.text else {
            return ""
        }

        return text
    }

    var confirmation: String {
        guard let text = passwordConfirmationTextField?.text else {
            return ""
        }

        return text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromNib()
        setupStyle()
    }

    private func initFromNib() {
        Bundle.main.loadNibNamed("NewPasswordFormView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        helperTextDelayTimer = DelayTimer(delay: helperTextDelayValue)
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.helperTextLabel?.textColor = .error
        self.helperTextLabel?.text = ""

        self.passwordTextField?.isSecureTextEntry = true
        self.passwordConfirmationTextField?.isSecureTextEntry = true

        self.passwordTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        self.passwordConfirmationTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)

        self.passwordTextField?.leftPadding = 16.0
        self.passwordTextField?.rightPadding = 16.0
        self.passwordConfirmationTextField?.leftPadding = 16.0
        self.passwordConfirmationTextField?.rightPadding = 16.0

        self.passwordTextField?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.passwordTextField?.textColor = .white

        let placeholderColor = UIColor.white.withAlphaComponent(0.2)
        let placeholderFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        let placeholderAttributedParameters = [
            NSAttributedString.Key.font: placeholderFont,
            NSAttributedString.Key.foregroundColor: placeholderColor
        ]

        let passwordPlaceholderString = NSAttributedString(string: "Password", attributes: placeholderAttributedParameters)
        let confirmationPlaceholderString = NSAttributedString(string: "Confirm your password", attributes: placeholderAttributedParameters)

        self.passwordTextField?.attributedPlaceholder = passwordPlaceholderString
        self.passwordConfirmationTextField?.attributedPlaceholder = confirmationPlaceholderString

        self.passwordConfirmationTextField?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.passwordConfirmationTextField?.textColor = .white

        self.passwordTextField?.addTarget(self, action: #selector(editingChangePasswordTextField(_:)), for: .editingChanged)
        self.passwordConfirmationTextField?.addTarget(self, action: #selector(editingChangePasswordConfirmationTextField(_:)), for: .editingChanged)

        self.passwordTextField?.addTarget(self, action: #selector(didEndEditingPasswordTextField(_:)), for: .editingDidEnd)
        self.passwordConfirmationTextField?.addTarget(self, action: #selector(didEndEditingPasswordConfirmationTextField(_:)), for: .editingDidEnd)
    }

    @objc
    private func editingChangePasswordTextField(_ sender: UITextField) {
        delegate?.newPasswordFormComponentEditingChange(self)

        guard
            let password = sender.text,
            let confirmation = passwordConfirmationTextField?.text else {
                return
        }

        performWithDelay {
            [weak self] in
            self?.checkConditions(password: password, confirmation: confirmation)
        }
    }

    @objc
    private func editingChangePasswordConfirmationTextField(_ sender: UITextField) {
        delegate?.newPasswordFormComponentEditingChange(self)

        guard
            let confirmation = sender.text,
            let password = passwordTextField?.text else {
                return
        }

        performWithDelay {
            [weak self] in
            self?.checkConditions(password: password, confirmation: confirmation)
        }
    }

    @objc
    private func didEndEditingPasswordTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
        sender.layoutIfNeeded()
    }

    @objc
    private func didEndEditingPasswordConfirmationTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
        sender.layoutIfNeeded()
    }

    private func checkConditions(password: String, confirmation: String) {

        switch (password == confirmation, password.count >= 6) {
        case (true, true):
            helperTextDelayTimer?.fire()
            
            self.helperTextLabel?.text = ""
            delegate?.newPasswordFormComponentSatisfiesAllConditions(self)
        case (true, false):
            let failedCondition = Conditions.Password.passwordMatchesSymbolsCount
            helperTextDelayTimer?.addOperation {
                [weak self] in

                guard password != "" else {
                    self?.helperTextLabel?.text = ""
                    return
                }

                self?.helperTextLabel?.text = failedCondition.rawValue
            }.fire()

            delegate?.newPasswordFormComponent(self, dontSatisfyTheCondition: failedCondition)
        case (false, true):
            let failedCondition = Conditions.Password.passwordFieldsMatch

            helperTextDelayTimer?.addOperation {
                [weak self] in

                guard confirmation != "" else {
                    self?.helperTextLabel?.text = ""
                    return
                }

                self?.helperTextLabel?.text = failedCondition.rawValue
            }.fire()

            delegate?.newPasswordFormComponent(self, dontSatisfyTheCondition: failedCondition)
        case (false, false):
            let failedCondition = Conditions.Password.passwordMatchesSymbolsCount

            helperTextDelayTimer?.addOperation {
                [weak self] in

                self?.helperTextLabel?.text = failedCondition.rawValue
            }.fire()

            delegate?.newPasswordFormComponent(self, dontSatisfyTheCondition: failedCondition)
        }
    }
}
