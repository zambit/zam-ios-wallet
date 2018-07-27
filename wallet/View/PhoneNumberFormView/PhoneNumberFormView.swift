//
//  PhoneNumberFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class PhoneNumberFormView: UIView, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet var detailPhonePartTextField: UITextField?
    @IBOutlet var mainPhonePartTextField: UITextField?

    var text: String {
        var result: String = ""

        if let detail = detailPhonePartTextField?.text {
            result.append("\(detail)")
        }

        if let main = mainPhonePartTextField?.text {
            result.append("\(main)")
        }

        return result
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
        Bundle.main.loadNibNamed("PhoneNumberFormView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.detailPhonePartTextField?.keyboardType = .phonePad
        self.mainPhonePartTextField?.keyboardType = .phonePad

        self.detailPhonePartTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        self.mainPhonePartTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)

        self.detailPhonePartTextField?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        self.mainPhonePartTextField?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)

        self.detailPhonePartTextField?.textColor = .white
        self.mainPhonePartTextField?.textColor = .white

        self.detailPhonePartTextField?.delegate = self
        self.mainPhonePartTextField?.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == detailPhonePartTextField {
            return detailTextFieldShouldChangeCharactersIn(range: range, replacementString: string)
        }

        if textField == mainPhonePartTextField {
            return mainTextFieldShouldChangeCharactersIn(range: range, replacementString: string)
        }

        return true
    }

    private func detailTextFieldShouldChangeCharactersIn(range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "+1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    private func mainTextFieldShouldChangeCharactersIn(range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "()1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
