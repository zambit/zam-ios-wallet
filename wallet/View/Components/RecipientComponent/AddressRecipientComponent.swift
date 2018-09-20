//
//  AddressRecipientComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 19/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol AddressRecipientComponentDelegate: class {

    func addressRecipientComponentStatusChanged(_ addressRecipientComponent: AddressRecipientComponent, to status: FormEditingStatus)
}

class AddressRecipientComponent: UIView {

    weak var delegate: AddressRecipientComponentDelegate?

    fileprivate var detailButton: HighlightableButton?
    fileprivate var textField: UITextField?

    fileprivate var detailButtonLeadingConstraint: NSLayoutConstraint?
    fileprivate var textFieldTrailingConstraint: NSLayoutConstraint?

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

    @objc
    fileprivate func detailButtonTouchUpInsideEvent(_ sender: UITextField) {

    }
}

extension BehaviorExtension where Base: AddressRecipientComponent {

    var address: String {
        return base.textField?.text ?? ""
    }

    var isEditing: Bool {
        return base.textField?.isEditing ?? false
    }

    func setup(address: String) {
        base.textField?.text = address
        textFieldEditingDidBegin()
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
                self.base.detailButtonLeadingConstraint?.constant = -40.0
                self.base.layoutIfNeeded()
            }, completion: nil)

        case .disappeared:
            UIView.animate(withDuration: 0.05, animations: {
                self.base.textField?.alpha = 0.0
                block(self.base)
            })

            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                self.base.detailButtonLeadingConstraint?.constant = 0.0
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

    func addDetailButtonTouchUpInsideEvent(target: Any?, action: Selector) {
        base.detailButton?.addTarget(target, action: action, for: .touchUpInside)
    }

    fileprivate func setup() {
        setupStyle()
        setupSubviews()
    }

    fileprivate func setupSubviews() {
        base.viewWithTag(2052420)?.removeFromSuperview()
        base.viewWithTag(315168)?.removeFromSuperview()

        let textField = UITextField()
        textField.tag = 2052420
        textField.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.attributedPlaceholder =
            NSAttributedString(string: "Address",
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
        textField.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 16.0).isActive = true
        base.textFieldTrailingConstraint = textField.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -16.0)
        base.textFieldTrailingConstraint?.isActive = true
        textField.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true

        base.textField = textField


        let detailButton = HighlightableButton()
        detailButton.tag = 315168
        detailButton.contentEdgeInsets = UIEdgeInsets.zero
        detailButton.setImage(#imageLiteral(resourceName: "maximize"), for: .normal)
        detailButton.tintColor = .white
        detailButton.setHighlightedTintColor(UIColor.white.withAlphaComponent(0.2))
        detailButton.addTarget(self, action: #selector(base.detailButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        base.addSubview(detailButton)

        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalTo: detailButton.heightAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        base.detailButtonLeadingConstraint = detailButton.leadingAnchor.constraint(equalTo: base.trailingAnchor, constant: 0)
        base.detailButtonLeadingConstraint?.isActive = true

        base.detailButton = detailButton

        base.layoutIfNeeded()
    }

    fileprivate func setupStyle() {
        base.backgroundColor = .clear
    }

    fileprivate func textFieldEditingDidBegin() {
        base.textFieldTrailingConstraint?.constant = -56
        base.layoutIfNeeded()
    }

    fileprivate func textFieldEditingChanged() {
        var newStatus: FormEditingStatus
        if let text = base.textField?.text, text.isEmpty || base.textField == nil {
            newStatus = .invalid
        } else {
            newStatus = .valid
        }

        if base.status != newStatus {
            base.status = newStatus
            base.delegate?.addressRecipientComponentStatusChanged(base, to: newStatus)
        }
    }

    fileprivate func textFieldEditingDidEnd() {
        guard let text = base.textField?.text, text.isEmpty else {
            return
        }

        base.textFieldTrailingConstraint?.constant = -16
        base.layoutIfNeeded()
    }
}
