//
//  PhoneNumberCodeTextField.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class PhoneNumberCodeTextField: UITextField, UITextFieldDelegate {

    let allowedCharacters = CharacterSet(charactersIn: "1234567890")

    override open var text: String? {
        set {
            if let value = newValue {
                let number = value.filter {
                    "1234567890".contains($0)
                }

                super.text = "+\(number)"
            } else {
                super.text = newValue
            }
        }

        get {
            return super.text
        }
    }

    weak private var _delegate: UITextFieldDelegate?

    override open var delegate: UITextFieldDelegate? {
        get {
            return _delegate
        }
        set {
            self._delegate = newValue
        }
    }

    //MARK: Lifecycle

    /**
     Init with frame

     - parameter frame: UITextField frame

     - returns: UITextfield
     */
    override public init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()

        self.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    /**
     Init with coder

     - parameter aDecoder: decoder

     - returns: UITextfield
     */
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()

        self.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    func setup() {
        self.autocorrectionType = .no
        self.keyboardType = UIKeyboardType.phonePad
        super.delegate = self
    }

    // MARK: - UITextFieldDelegate

    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        textField.text?.addPrefixIfNeeded("+")
    }

    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // allow delegate to intervene
        guard _delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true else {
            return false
        }

        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        guard _delegate == nil else {
            _delegate?.textFieldDidBeginEditing?(textField)
            return
        }

        textField.text?.addPrefixIfNeeded("+")
    }

    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        guard _delegate == nil else {
             _delegate?.textFieldDidEndEditing?(textField)
            return
        }

        textField.resignFirstResponder()
        textField.layoutIfNeeded()

        if let text = textField.text, text == "+" {
            textField.text = ""
        }
    }

    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldClear?(textField) ?? true
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldReturn?(textField) ?? true
    }
}
