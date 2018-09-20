//
//  PhoneNumberRecipientComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 19/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol PhoneNumberRecipientComponentDelegate: class {

    func phoneNumberRecipientComponentStatusChanged(_ phoneNumberRecipientComponent: PhoneNumberRecipientComponent, to status: FormEditingStatus)
}

class PhoneNumberRecipientComponent: UIView {

    weak var delegate: PhoneNumberRecipientComponentDelegate?

    fileprivate var phoneNumberFormatter: PhoneNumberFormatter!

    fileprivate var resultingString: String = ""

    fileprivate var detailButton: HighlightableButton?
    fileprivate var textField: PhoneNumberTextField?

    fileprivate var detailButtonTrailingConstraint: NSLayoutConstraint?
    fileprivate var textFieldLeadingConstraint: NSLayoutConstraint?

    fileprivate var state: DisplayState = .disappeared
    fileprivate var status: FormEditingStatus = .invalid

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setup()
    }

    @objc
    fileprivate func textFieldEditingDidBegin(_ sender: UITextField) {
        custom.textFieldEditingDidBegin()
    }

    @objc
    fileprivate func textFieldEditingChanged(_ sender: UITextField) {
        custom.textFieldEditingChanged()
    }

    @objc
    fileprivate func textFieldEditingDidEnd(_ sender: UITextField) {
        custom.textFieldEditingDidEnd()
    }
}

extension BehaviorExtension where Base: PhoneNumberRecipientComponent {

    var phone: String {
        return base.resultingString
    }

    var isEditing: Bool {
        return base.textField?.isEditing ?? false
    }

    func setup(contact: ContactData) {
        base.textField?.text = contact.phoneNumbers.first
        textFieldEditingDidBegin()

        if let data = contact.avatarData, let avatar = UIImage(data: data, scale: 0.3) {
            base.detailButton?.setImage(avatar, for: UIControlState())
        }
    }

    func set(state: DisplayState, animation block: @escaping (UIView) -> Void = { _ in }) {
        base.state = state

        switch state {
        case .appeared:
            UIView.animate(withDuration: 0.05, animations: {
                self.base.textField?.alpha = 1.0
                block(self.base)
            })

            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                self.base.detailButtonTrailingConstraint?.constant = 54.0
                self.base.layoutIfNeeded()
            }, completion: nil)

        case .disappeared:
            UIView.animate(withDuration: 0.05, animations: {
                self.base.textField?.alpha = 0.0
                block(self.base)
            })

            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                self.base.detailButtonTrailingConstraint?.constant = 0.0
                self.base.layoutIfNeeded()
            }, completion: nil)
        }
    }

    func beginEditing() {
        base.textField?.becomeFirstResponder()
    }

    func endEditing() {
        base.textField?.resignFirstResponder()
    }

    fileprivate func setup() {
        base.phoneNumberFormatter = PhoneNumberFormatter()
        setupStyle()
        setupSubviews()
    }

    fileprivate func setupSubviews() {
        base.viewWithTag(2052420)?.removeFromSuperview()
        base.viewWithTag(315168)?.removeFromSuperview()

        let textField = PhoneNumberTextField()
        textField.tag = 2052420
        textField.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.attributedPlaceholder =
            NSAttributedString(string: "Phone number",
                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11.0
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(base.textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(base.textFieldEditingChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(base.textFieldEditingDidEnd(_:)), for: .editingDidEnd)

        base.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        base.textFieldLeadingConstraint = textField.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 16.0)
        base.textFieldLeadingConstraint?.isActive = true
        textField.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -16.0).isActive = true
        textField.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true

        base.textField = textField


        let detailButton = HighlightableButton()
        detailButton.tag = 315168
        detailButton.circleCorner = true
        detailButton.contentEdgeInsets = UIEdgeInsets.zero
        detailButton.setImage(#imageLiteral(resourceName: "contactPlaceholder"), for: .normal)
        detailButton.tintColor = .white
        detailButton.setHighlightedTintColor(UIColor.white.withAlphaComponent(0.2))

        base.addSubview(detailButton)

        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalTo: detailButton.heightAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        base.detailButtonTrailingConstraint = detailButton.trailingAnchor.constraint(equalTo: base.leadingAnchor, constant: 0)
        base.detailButtonTrailingConstraint?.isActive = true

        base.detailButton = detailButton

        base.layoutIfNeeded()
    }

    fileprivate func setupStyle() {
        base.backgroundColor = .clear
    }

    fileprivate func textFieldEditingDidBegin() {
        base.textFieldLeadingConstraint?.constant = 40
        base.layoutIfNeeded()
    }

    fileprivate func textFieldEditingChanged() {
        guard let phone = base.textField?.text, phone.count > 1 else {
            base.resultingString = ""
            return
        }

        base.phoneNumberFormatter.number = phone
        base.resultingString = base.phoneNumberFormatter.formatted
        base.textField?.text = base.resultingString

        var newStatus: FormEditingStatus
        if base.phoneNumberFormatter.isValid {
            newStatus = .valid
        } else {
            newStatus = .invalid
        }

        if base.status != newStatus {
            base.status = newStatus
            base.delegate?.phoneNumberRecipientComponentStatusChanged(base, to: newStatus)
        }
    }

    fileprivate func textFieldEditingDidEnd() {
        guard let text = base.textField?.text, text.count < 2 else {
            return
        }

        base.textFieldLeadingConstraint?.constant = 16
        base.layoutIfNeeded()
    }
}
