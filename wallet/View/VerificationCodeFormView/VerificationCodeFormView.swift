//
//  VerificationCodeFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class VerificationCodeFormView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var codeTextField: UITextField?

    var text: String {
        guard let text = codeTextField?.text else {
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
        let placeholderFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let placeholderAttributedParameters = [
            NSAttributedStringKey.font: placeholderFont,
            NSAttributedStringKey.foregroundColor: placeholderColor]

        let placeholderString = NSAttributedString(string: "•• •• ••", attributes: placeholderAttributedParameters)
        self.codeTextField?.attributedPlaceholder = placeholderString
    }

}
