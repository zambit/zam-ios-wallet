//
//  LoginPasswordFormViewController.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol LoginPasswordComponentDelegate: class {

    func loginPasswordFormComponentCanChangeHelperText(_ loginPasswordFormComponent: LoginPasswordFormComponent) -> Bool

    func loginPasswordFormComponentEditingChange(_ loginPasswordFormComponent: LoginPasswordFormComponent)

    func loginPasswordFormComponent(_ loginPasswordFormComponent: LoginPasswordFormComponent, dontSatisfyTheCondition: Conditions.Password)

    func loginPasswordFormComponentSatisfiesAllConditions(_ loginPasswordFormComponent: LoginPasswordFormComponent)

}

extension LoginPasswordComponentDelegate {

    func loginPasswordFormComponentCanChangeHelperText(_ loginPasswordFormComponent: LoginPasswordFormComponent) -> Bool {
        return true
    }

    func loginPasswordFormComponentEditingChange(_ loginPasswordFormComponent: LoginPasswordFormComponent) {}

}

class LoginPasswordFormComponent: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var passwordTextField: UITextField?
    @IBOutlet private var helperTextLabel: UILabel?

    weak var delegate: LoginPasswordComponentDelegate?

    var password: String {
        guard let text = passwordTextField?.text else {
            return ""
        }

        return text
    }

    var helperText: String {
        get {
            return helperTextLabel?.text ?? ""
        }

        set {
            helperTextLabel?.text = newValue
        }
    }

    private var helperTextWithDelegateCheck: String {
        get {
            return helperTextLabel?.text ?? ""
        }

        set {
            if let delegate = delegate, !delegate.loginPasswordFormComponentCanChangeHelperText(self) {
                // do nothing
            } else {
                helperTextLabel?.text = newValue
            }
        }
    }

    /**
     Timer for performing helperText changing with some delay
     */
    private var helperTextDelayTimer: DelayTimer?
    private var helperTextDelayValue: Double = 1.0

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
        Bundle.main.loadNibNamed("LoginPasswordFormView", owner: self, options: nil)
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

        self.passwordTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)

        self.passwordTextField?.leftPadding = 16.0
        self.passwordTextField?.rightPadding = 16.0

        self.passwordTextField?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.passwordTextField?.textColor = .white

        let placeholderColor = UIColor.white.withAlphaComponent(0.2)
        let placeholderFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        let placeholderAttributedParameters = [
            NSAttributedString.Key.font: placeholderFont,
            NSAttributedString.Key.foregroundColor: placeholderColor
        ]

        let passwordPlaceholderString = NSAttributedString(string: "Password", attributes: placeholderAttributedParameters)

        self.passwordTextField?.attributedPlaceholder = passwordPlaceholderString

        self.passwordTextField?.addTarget(self, action: #selector(editingChangePasswordTextField(_:)), for: .editingChanged)
        self.passwordTextField?.addTarget(self, action: #selector(didEndEditingPasswordTextField(_:)), for: .editingDidEnd)
    }

    @objc
    private func editingChangePasswordTextField(_ sender: UITextField) {
        delegate?.loginPasswordFormComponentEditingChange(self)
        checkConditions(password: password)
    }

    @objc
    private func didEndEditingPasswordTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
        sender.layoutIfNeeded()
    }

    private func checkConditions(password: String) {
        switch password.count >= 6 {
        case true:
            helperTextDelayTimer?.fire()
            
            helperTextWithDelegateCheck = ""
            delegate?.loginPasswordFormComponentSatisfiesAllConditions(self)
        case false:
            let failedCondition = Conditions.Password.passwordMatchesSymbolsCount

            helperTextDelayTimer?.addOperation {
                [weak self] in

                guard password != "" else {
                    self?.helperTextWithDelegateCheck = ""
                    return
                }

                self?.helperTextWithDelegateCheck = failedCondition.rawValue
            }.fire()

            delegate?.loginPasswordFormComponent(self, dontSatisfyTheCondition: failedCondition)
        }
    }
}
