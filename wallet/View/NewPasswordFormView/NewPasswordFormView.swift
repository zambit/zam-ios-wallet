//
//  NewPasswordFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class NewPasswordFormView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var passwordTextField: UITextField?
    @IBOutlet var passwordConfirmationTextField: UITextField?

    weak var delegate: NewPasswordFormViewDelegate?

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
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.passwordTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        self.passwordConfirmationTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)

//        self.passwordTextField?.leftPadding = 24.0
//        self.passwordTextField?.rightPadding = 24.0
//        self.passwordConfirmationTextField?.leftPadding = 24.0
//        self.passwordConfirmationTextField?.rightPadding = 24.0

        self.passwordTextField?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.passwordTextField?.textColor = .white

        self.passwordConfirmationTextField?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.passwordConfirmationTextField?.textColor = .white

        //self.passwordTextField?.addTarget(self, action: #selector(didEndEditingPasswordTextField(_:)), for: .editingDidEnd)
        //self.passwordConfirmationTextField?.addTarget(self, action: #selector(didEndEditingPasswordConfirmationTextField(_:)), for: .editingDidEnd)
    }

    @objc
    private func didEndEditingPasswordTextField(_ sender: UITextField) {
        guard
            let password = sender.text,
            let confirmation = passwordConfirmationTextField?.text else {
            return
        }

        if password != confirmation {
            delegate?.passwordsDontMatch(self, password: password, confirmation: confirmation)
        }
    }

    @objc
    private func didEndEditingPasswordConfirmationTextField(_ sender: UITextField) {
        guard
            let confirmation = sender.text,
            let password = passwordTextField?.text else {
                return
        }

        if password != confirmation {
            delegate?.passwordsDontMatch(self, password: password, confirmation: confirmation)
        }
    }

}

protocol NewPasswordFormViewDelegate: class {

    func passwordsDontMatch(_ newPasswordFormView: NewPasswordFormView, password: String, confirmation: String)

}
