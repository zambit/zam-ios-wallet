//
//  VerificationCodeFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol VerificationCodeFormComponentDelegate: class {

    func verificationCodeFormComponent(_ verificationCodeFormComponent: VerificationCodeFormComponent, codeEnteringIsCompleted: Bool)

}

class VerificationCodeFormComponent: UIView, UITextFieldDelegate {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var codeTextField: UITextField?

    @IBOutlet private var verificationTextFieldHeightConstraint: NSLayoutConstraint?

    weak var delegate: VerificationCodeFormComponentDelegate?

    var textFieldHeight: CGFloat {
        get {
            return verificationTextFieldHeightConstraint?.constant ?? 0
        }

        set {
            verificationTextFieldHeightConstraint?.constant = newValue
        }
    }

    var codeMask: String = "XX XX XX"

    var text: String {
        guard let text = codeTextField?.text else {
            return ""
        }

        let numbers = text.filter {
            "1234567890".contains($0)
        }

        return numbers
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
        Bundle.main.loadNibNamed("VerificationCodeFormView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.codeTextField?.keyboardType = .decimalPad

        self.codeTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        self.codeTextField?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.codeTextField?.textColor = .white

        let placeholderColor = UIColor.white.withAlphaComponent(0.2)
        let placeholderFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let placeholderAttributedParameters = [
            NSAttributedStringKey.font: placeholderFont,
            NSAttributedStringKey.foregroundColor: placeholderColor]

        let placeholderString = NSAttributedString(string: "• •   • •   • •", attributes: placeholderAttributedParameters)
        self.codeTextField?.attributedPlaceholder = placeholderString

        self.codeTextField?.textAlignment = .center

        self.codeTextField?.delegate = self
    }

    private func checkForComplete() -> Bool {
        guard let codeText = codeTextField?.text else {
                return false
        }

        return codeText.count >= codeMask.count
    }

    // - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)

        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }

        guard let text = codeTextField?.text else {
            return true
        }

        if let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let maskedText = MaskParser(symbol: "X", space: " ").matchingStrict(text: updatedText, withMask: codeMask)

            codeTextField?.text = maskedText
            
            delegate?.verificationCodeFormComponent(self, codeEnteringIsCompleted: checkForComplete())
            return false
        }

        return true
    }
}
