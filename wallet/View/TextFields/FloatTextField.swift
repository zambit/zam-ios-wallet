//
//  FloatTextField.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class FloatTextField: UITextField, UITextFieldDelegate {

    enum FloatingState {
        case editing
        case placeholder
    }

    fileprivate(set) var floatingState: FloatingState = .placeholder
    fileprivate(set) var floatingPlaceholder: String?

    fileprivate var placeholderLabel: UILabel?
    fileprivate var placeholderLabelTopConstraint: NSLayoutConstraint?

    fileprivate var floatingPlaceholderLabel: UILabel?
    fileprivate var floatingPlaceholderLabelTopConstraint: NSLayoutConstraint?

    override var placeholder: String? {
        didSet {
            self.placeholder = nil
        }
    }

    override var text: String? {
        didSet {
            custom.setup(text: text)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.delegate = self
    }

    fileprivate var padding = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    //MARK: UITextfieldDelegate

    weak private var _delegate: UITextFieldDelegate?

    override open var delegate: UITextFieldDelegate? {
        get {
            return _delegate
        }
        set {
            self._delegate = newValue
        }
    }

    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let shouldBeginEditing = _delegate?.textFieldShouldBeginEditing?(textField) ?? true
        if shouldBeginEditing {
            custom.changeState(to: .editing)
        }
        return shouldBeginEditing
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField)
    }

    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let shouldEndEditing = _delegate?.textFieldShouldEndEditing?(textField) ?? true
        if shouldEndEditing, (textField.text ?? "").isEmpty {
            custom.changeState(to: .placeholder)
        }
        return shouldEndEditing
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        _delegate?.textFieldDidEndEditing?(textField)
    }

    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldClear?(textField) ?? true
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldReturn?(textField) ?? true
    }
}

extension BehaviorExtension where Base: FloatTextField {

    func setup(placeholder: String) {
        base.floatingPlaceholder = placeholder
        setupSubviews()
    }

    func setup(text: String?) {
        if base.text != text {
            base.text = text
        }

        if (text ?? "").isEmpty {
            self.base.floatingPlaceholderLabel?.alpha = 0
            self.base.floatingPlaceholderLabelTopConstraint?.constant = 28.0

            self.base.placeholderLabel?.alpha = 1
            self.base.placeholderLabelTopConstraint?.constant = 0
        } else {
            self.base.floatingPlaceholderLabel?.alpha = 1.0
            self.base.floatingPlaceholderLabelTopConstraint?.constant = 10.0

            self.base.placeholderLabel?.alpha = 0
            self.base.placeholderLabelTopConstraint?.constant = -10
        }
    }

    fileprivate func setupSubviews() {
        base.viewWithTag(16121)?.removeFromSuperview()
        base.viewWithTag(13242)?.removeFromSuperview()

        let floatingPlaceholderLabel = UILabel()
        floatingPlaceholderLabel.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        floatingPlaceholderLabel.textColor = .blueGrey
        floatingPlaceholderLabel.tag = 16121
        floatingPlaceholderLabel.text = base.floatingPlaceholder
        floatingPlaceholderLabel.alpha = 0.0

        base.addSubview(floatingPlaceholderLabel)

        floatingPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false

        floatingPlaceholderLabel.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 16.0).isActive = true
        base.floatingPlaceholderLabelTopConstraint = floatingPlaceholderLabel.topAnchor.constraint(equalTo: base.topAnchor, constant: 28.0)
        base.floatingPlaceholderLabelTopConstraint?.isActive = true

        base.floatingPlaceholderLabel = floatingPlaceholderLabel


        let placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        placeholderLabel.textColor = .blueGrey
        placeholderLabel.tag = 13242
        placeholderLabel.text = base.floatingPlaceholder

        base.addSubview(placeholderLabel)
        base.bringSubviewToFront(placeholderLabel)

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 16.0).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -16.0).isActive = true
        base.placeholderLabelTopConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor)
        base.placeholderLabelTopConstraint?.isActive = true

        base.placeholderLabel = placeholderLabel
    }

    fileprivate func changeState(to state: Base.FloatingState) {
        base.floatingState = state

        UIView.animate(withDuration: 0.15) {
            switch state {
            case .placeholder:
                self.base.floatingPlaceholderLabel?.alpha = 0
                self.base.floatingPlaceholderLabelTopConstraint?.constant = 28.0

                self.base.placeholderLabel?.alpha = 1
                self.base.placeholderLabelTopConstraint?.constant = 0

            case .editing:
                self.base.floatingPlaceholderLabel?.alpha = 1.0
                self.base.floatingPlaceholderLabelTopConstraint?.constant = 10.0

                self.base.placeholderLabel?.alpha = 0
                self.base.placeholderLabelTopConstraint?.constant = -10
            }

            self.base.layoutIfNeeded()
        }
    }
}
