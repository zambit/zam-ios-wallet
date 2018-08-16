//
//  PhoneNumberEnteringHandler.swift
//  wallet
//
//  Created by  me on 15/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

protocol PhoneNumberEnteringHandlerDelegate: class {

    func phoneNumberMaskChanged(_ handler: PhoneNumberEnteringHandler, from oldValue: PhoneMaskData?, to newValue: PhoneMaskData?)

    func phoneNumberEditingChanged(_ handler: PhoneNumberEnteringHandler, with mask: PhoneMaskData?, phoneNumber: String)

}

class PhoneNumberEnteringHandler: NSObject, UITextFieldDelegate {

    weak var delegate: PhoneNumberEnteringHandlerDelegate?

    private let masks: [String: PhoneMaskData]
    private let maskParser: MaskParser

    private var mask: PhoneMaskData? {
        didSet {
            delegate?.phoneNumberMaskChanged(self, from: oldValue, to: mask)
        }
    }

    private var maskRangeInUnitedTextField: CountableRange<Int>?

    private weak var codeTextField: UITextField?
    private weak var numberTextField: UITextField?

    private weak var unitedTextField: UITextField?

    init(textField: UITextField, masks: [String: PhoneMaskData], maskParser: MaskParser) {
        self.masks = masks
        self.maskParser = maskParser
        self.unitedTextField = textField

        super.init()

        unitedTextField?.addTarget(self, action: #selector(unitedTextFieldEditingBegin(_:)), for: .editingDidBegin)
        unitedTextField?.addTarget(self, action: #selector(unitedTextFieldEditingChanged(_:)), for: .editingChanged)
        unitedTextField?.addTarget(self, action: #selector(unitedTextFieldEndEditing(_:)), for: .editingDidEnd)

        self.unitedTextField?.delegate = self
    }


    init(codeTextField: UITextField, numberTextField: UITextField, masks: [String: PhoneMaskData], maskParser: MaskParser) {
        self.masks = masks
        self.maskParser = maskParser
        self.numberTextField = numberTextField
        self.codeTextField = codeTextField

        super.init()

        codeTextField.addTarget(self, action: #selector(textFieldEditingEnd(_:)), for: .editingDidEnd)
        codeTextField.addTarget(self, action: #selector(codeTextFieldEditingBegin(_:)), for: .editingDidBegin)
        codeTextField.addTarget(self, action: #selector(codeTextFieldEditingChanged(_:)), for: .editingChanged)

        numberTextField.addTarget(self, action: #selector(textFieldEditingEnd(_:)), for: .editingDidEnd)
        numberTextField.addTarget(self, action: #selector(numberTextFieldEditingChanged(_:)), for: .editingChanged)

        self.codeTextField?.delegate = self
        self.numberTextField?.delegate = self
    }

    // MARK: - UnitedTextField

    @objc
    private func unitedTextFieldEditingBegin(_ sender: UITextField) {
        sender.text?.addPrefixIfNeeded("+")
    }

    @objc
    private func unitedTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        sender.text?.addPrefixIfNeeded("+")

        guard text.count > 1 else {
            return
        }

        for i in 1..<text.count {
            let code = text[0..<i]
            mask = masks.filter { "+\($0.key)" == code }.first?.1

            if let curMask = mask {
                maskRangeInUnitedTextField = 0..<i

                let numberStartIndex = text[i] == " " ? i + 1 : i
                let number = text[numberStartIndex..<text.count]
                let maskedNumber = maskParser.matchingUnstrict(text: number, withMask: curMask.phoneMask)

                let maskedText = "\(code) \(maskedNumber)"
                sender.text = maskedText

                delegate?.phoneNumberEditingChanged(self, with: curMask, phoneNumber: maskedText)
                break
            }
        }

        delegate?.phoneNumberEditingChanged(self, with: mask, phoneNumber: text)
    }

    @objc
    private func unitedTextFieldEndEditing(_ sender: UITextField) {
        guard let text = sender.text, text == "+" else {
            return
        }

        sender.text = ""
    }

    // MARK: - CodeTextField

    @objc
    private func codeTextFieldEditingBegin(_ sender: UITextField) {
        sender.text?.addPrefixIfNeeded("+")
    }

    @objc
    private func codeTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        sender.text?.addPrefixIfNeeded("+")

        mask = masks.filter { "+\($0.key)" == text }.first?.1

        // update mainTextField
        if let mask = mask?.phoneMask,
            let mainText = numberTextField?.text {
            numberTextField?.text = maskParser.matchingUnstrict(text: mainText, withMask: mask)
        }

        numberTextFieldEditingChanged(sender)
    }

    // MARK: - NumberTextField

    @objc
    private func numberTextFieldEditingChanged(_ sender: UITextField) {
        let mainText = numberTextField?.text ?? ""
        delegate?.phoneNumberEditingChanged(self, with: mask, phoneNumber: mainText)
    }

    // MARK: - TextField

    @objc
    private func textFieldEditingEnd(_ sender: UITextField) {
        sender.resignFirstResponder()
        sender.layoutIfNeeded()
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let codeTextField = codeTextField, textField == codeTextField {
            return self.codeTextField(codeTextField, shouldChangeCharactersIn: range, replacementString: string)
        }

        if let numberTextField = numberTextField, textField == numberTextField {
            return self.numberTextField(numberTextField, shouldChangeCharactersIn: range, replacementString: string)
        }

        if let unitedTextField = unitedTextField, textField == unitedTextField {
            return self.unitedTextField(unitedTextField, shouldChangeCharactersIn: range, replacementString: string)
        }

        return true
    }

    private func codeTextField(_ codeTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    private func numberTextField(_ numberTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)

        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }

        guard let text = numberTextField.text else {
            return true
        }

        if let textRange = Range(range, in: text),
            let mask = mask?.phoneMask {

            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let maskedText = maskParser.matchingUnstrict(text: updatedText, withMask: mask)

            numberTextField.text = maskedText
            numberTextFieldEditingChanged(numberTextField)
            
            return false
        }

        return true
    }

    private func unitedTextField(_ unitedTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)

        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }

        return true
    }
}
