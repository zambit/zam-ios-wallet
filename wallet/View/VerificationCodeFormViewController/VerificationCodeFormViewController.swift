//
//  VerificationCodeFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol VerificationCodeFormViewDelegate: class {

    func verificationCodeFormViewController(_ verificationCodeFormViewController: VerificationCodeFormViewController, codeEnteringIsCompleted: Bool)

}

class VerificationCodeFormViewController: UIView, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet var codeTextField: UITextField?

    weak var delegate: VerificationCodeFormViewDelegate?

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
            let maskedText = matching(text: updatedText, withMask: codeMask)

            codeTextField?.text = maskedText
            
            delegate?.verificationCodeFormViewController(self, codeEnteringIsCompleted: checkForComplete())
            return false
        }

        return true
    }

    private func matching(text: String, withMask mask: String) -> String {

        var resulting: String = ""
        var textIndex: Int = 0

        for character in mask {
            if !(textIndex < text.count) {
                return resulting
            }

            switch character {
            case " ":
                resulting.append(" ")

                if text[textIndex] == " " {
                    textIndex += 1
                }

            case "X":
                if text[textIndex] != " " {
                    resulting.append(text[textIndex])
                }

                textIndex += 1

            default:
                fatalError()
            }
        }

        return resulting
    }

}
