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
        case small
        case normal
    }

    var floatingState: FloatingState = .normal

    var floatingPlaceholder: String? {
        didSet {
            if floatingState == .normal {
                custom.setupSubviews()
            }
        }
    }

    var placeholderLabel: UILabel?
    var placeholderLabelBottomConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        super.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        super.delegate = self
    }

    var padding = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
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
            custom.changeState(to: .small)
        }
        return shouldBeginEditing
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField)
    }

    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let shouldEndEditing = _delegate?.textFieldShouldEndEditing?(textField) ?? true
        if shouldEndEditing, (textField.text ?? "").isEmpty {
            custom.changeState(to: .normal)
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
        base.placeholder = ""
    }

    func setupSubviews() {
        base.viewWithTag(16121)?.removeFromSuperview()

        let placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.walletFont(ofSize: 18.0, weight: .regular)
        placeholderLabel.textColor = .blueGrey
        placeholderLabel.tag = 16121
        placeholderLabel.text = base.floatingPlaceholder

        base.addSubview(placeholderLabel)
        base.bringSubview(toFront: placeholderLabel)

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 16.0).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: base.topAnchor, constant: 4.0).isActive = true
        base.placeholderLabelBottomConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -4.0)
        base.placeholderLabelBottomConstraint?.isActive = true
        //placeholderLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true

        base.placeholderLabel = placeholderLabel
    }

    func changeState(to state: Base.FloatingState) {
        base.floatingState = state

        UIView.animate(withDuration: 0.15) {
            [weak self] in

            guard let strongBase = self?.base else {
                return
            }

            switch state {
            case .normal:
                strongBase.placeholderLabel?.layer.anchorPoint = .zero
                strongBase.placeholderLabel?.transform = .identity
                strongBase.placeholderLabelBottomConstraint?.constant = -4.0

            case .small:
                strongBase.placeholderLabel?.layer.anchorPoint = CGPoint.zero
                strongBase.placeholderLabel?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                strongBase.placeholderLabelBottomConstraint?.constant = -45.0
            }

            strongBase.layoutIfNeeded()
        }
    }
}
