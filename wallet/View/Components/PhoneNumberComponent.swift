//
//  PhoneNumberComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import FlagKit

protocol PhoneNumberComponentDelegate: class {

    func phoneNumberComponentCanChangeHelperText(_ phoneNumberComponent: PhoneNumberComponent) -> Bool

    func phoneNumberComponent(_ phoneNumberComponent: PhoneNumberComponent, dontSatisfyTheCondition: PhoneCondition)

    func phoneNumberComponentSatisfiesAllConditions(_ phoneNumberComponent: PhoneNumberComponent)
}

extension PhoneNumberComponentDelegate {

    func phoneNumberComponentCanChangeHelperText(_ phoneNumberComponent: PhoneNumberComponent) -> Bool {
        return true
    }
}

class PhoneNumberComponent: UIView {

    weak var delegate: PhoneNumberComponentDelegate?

    fileprivate var phoneNumberFormatter: PhoneNumberFormatter!

    fileprivate var resultingString: String = ""

    /**
     Timer for performing helperText changing with some delay
     */
    fileprivate var helperTextDelayTimer: DelayTimer = DelayTimer(delay: 1.0)

    fileprivate var codeTextField: PartialPhoneNumberCodeTextField?
    fileprivate var phoneTextField: PartialPhoneNumberTextField?
    fileprivate var countryImageView: CountryView?

    fileprivate var helperLabel: UILabel?

    fileprivate var imageViewLeadingConstraint: NSLayoutConstraint?
    fileprivate var textFieldTrailingConstraint: NSLayoutConstraint?
    fileprivate var codeTextFieldWidthConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setup()
    }

    @objc
    fileprivate func phoneNumberCodeChanged(_ sender: PartialPhoneNumberCodeTextField) {
        custom.phoneNumberCodeChanged()
    }

    @objc
    fileprivate func phoneNumberChanged(_ sender: PartialPhoneNumberTextField) {
        custom.phoneNumberChanged()
    }
}

extension BehaviorExtension: SizePresetable where Base: PhoneNumberComponent {

    var phoneNumber: String {
        return base.resultingString
    }

    func prepare(preset: SizePreset) {
        switch preset {
        case .superCompact:
            base.codeTextFieldWidthConstraint?.constant = 50
            base.codeTextField?.leftPadding = 6.0
        case .compact, .default, .large:
            base.codeTextFieldWidthConstraint?.constant = 80
            base.codeTextField?.leftPadding = 12.0
        }

        base.layoutIfNeeded()
    }

    func setHelperText(_ text: String) {
        base.helperLabel?.text = text
    }

    fileprivate func setup() {
        base.phoneNumberFormatter = PhoneNumberFormatter()
        setupStyle()
        setupSubviews()

        base.codeTextField?.text = base.phoneNumberFormatter.defaultCode
        base.phoneNumberFormatter.number = base.phoneNumberFormatter.defaultCode
        setupCountryImageAnimationWith(state: CountryImageAnimationTask.show(country: base.phoneNumberFormatter.defaultRegion)) {}
    }

    fileprivate func setupSubviews() {
        base.viewWithTag(31545168)?.removeFromSuperview()
        base.viewWithTag(131914168)?.removeFromSuperview()
        base.viewWithTag(8512168)?.removeFromSuperview()
        base.viewWithTag(315168)?.removeFromSuperview()

        let codeTextField = PartialPhoneNumberCodeTextField()
        codeTextField.tag = 31545168
        codeTextField.font = UIFont.walletFont(ofSize: 20.0, weight: .regular)
        codeTextField.textColor = .white
        codeTextField.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        codeTextField.layer.cornerRadius = 8.0
        codeTextField.leftPadding = 12.0
        codeTextField.keyboardType = .decimalPad
        codeTextField.addTarget(self, action: #selector(base.phoneNumberCodeChanged(_:)), for: .editingChanged)
        codeTextField.attributedPlaceholder =
            NSAttributedString(string: "+",
                               attributes: [.font: UIFont.walletFont(ofSize: 20.0, weight: .regular),
                                            .foregroundColor: UIColor.white.withAlphaComponent(0.2)])

        base.addSubview(codeTextField)

        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 16.0).isActive = true
        codeTextField.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        base.codeTextFieldWidthConstraint = codeTextField.widthAnchor.constraint(equalToConstant: 80.0)
        base.codeTextFieldWidthConstraint?.isActive = true

        base.codeTextField = codeTextField


        let phoneTextField = PartialPhoneNumberTextField()
        phoneTextField.tag = 131914168
        phoneTextField.font = UIFont.walletFont(ofSize: 20.0, weight: .regular)
        phoneTextField.textColor = .white
        phoneTextField.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        phoneTextField.layer.cornerRadius = 8.0
        phoneTextField.leftPadding = 12.0
        phoneTextField.keyboardType = .decimalPad
        phoneTextField.addTarget(self, action: #selector(base.phoneNumberChanged(_:)), for: .editingChanged)

        base.addSubview(phoneTextField)

        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.leadingAnchor.constraint(equalTo: codeTextField.trailingAnchor, constant: 8.0).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: codeTextField.topAnchor).isActive = true
        phoneTextField.bottomAnchor.constraint(equalTo: codeTextField.bottomAnchor).isActive = true
        base.textFieldTrailingConstraint = phoneTextField.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -16.0)
        base.textFieldTrailingConstraint?.isActive = true

        base.phoneTextField = phoneTextField


        let helperLabel = UILabel()
        helperLabel.tag = 8512168
        helperLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
        helperLabel.textColor = .error
        helperLabel.textAlignment = .left
        helperLabel.numberOfLines = 1

        base.addSubview(helperLabel)

        helperLabel.translatesAutoresizingMaskIntoConstraints = false
        helperLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 8.0).isActive = true
        helperLabel.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        helperLabel.leadingAnchor.constraint(equalTo: codeTextField.leadingAnchor).isActive = true
        helperLabel.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor).isActive = true
        helperLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true

        base.helperLabel = helperLabel


        let countryImageView = CountryView()
        countryImageView.tag = 315168

        base.addSubview(countryImageView)

        countryImageView.translatesAutoresizingMaskIntoConstraints = false
        countryImageView.centerYAnchor.constraint(equalTo: phoneTextField.centerYAnchor).isActive = true
        countryImageView.widthAnchor.constraint(equalTo: countryImageView.heightAnchor).isActive = true
        countryImageView.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        base.imageViewLeadingConstraint = countryImageView.leadingAnchor.constraint(equalTo: base.trailingAnchor, constant: 0)
        base.imageViewLeadingConstraint?.isActive = true

        base.countryImageView = countryImageView

        base.layoutIfNeeded()
    }

    fileprivate func setupStyle() {
        base.backgroundColor = .clear
    }

    fileprivate func setHelperTextWithCheck(_ text: String) {
        if base.delegate?.phoneNumberComponentCanChangeHelperText(base) ?? true {
            setHelperText(text)
        }
    }

    fileprivate func phoneNumberCodeChanged() {
        guard let code = base.codeTextField?.text else {
            base.resultingString = ""
            return
        }

        guard code.count > 1 else {
            let country = base.phoneNumberFormatter.region

            let state = CountryImageAnimationTask.taskFrom(
                oldCountryNameValue: country,
                newCountryNameValue: nil
            )

            base.resultingString = ""
            base.phoneNumberFormatter.number = nil

            setupCountryImageAnimationWith(state: state) {}

            checkConditions(with: base.phoneNumberFormatter)
            return
        }

        // identify country

        let country = base.phoneNumberFormatter.region
        base.phoneNumberFormatter.number = code

        // determine if entered code is cleared identify by formatter
        if base.phoneNumberFormatter.code == nil || (base.phoneNumberFormatter.code?.count ?? 0) + 1 != code.count {
            base.phoneNumberFormatter.number = ""
        }

        let newCountry = base.phoneNumberFormatter.region

        let state = CountryImageAnimationTask.taskFrom(
            oldCountryNameValue: country,
            newCountryNameValue: newCountry
        )

        setupCountryImageAnimationWith(state: state) {}

        // divide between parts

        if newCountry != country {
            let phone = base.phoneTextField?.text ?? ""

            if newCountry != nil {
                // if code becomes be undefined after last entering update main part and change focus to it

                base.phoneNumberFormatter.number = code + phone
                base.resultingString = base.phoneNumberFormatter.formatted
                base.phoneTextField?.text = base.resultingString.deletingPrefix(code).deletingLeading(character: " ")
                base.phoneTextField?.becomeFirstResponder()
            } else {
                // if code becomes be undefined reset all formatting of main part

                base.resultingString = code + PhoneNumberFormatter.trivialString(from: phone)
                base.phoneTextField?.text = PhoneNumberFormatter.trivialString(from: phone)
            }
        }

        checkConditions(with: base.phoneNumberFormatter)
    }

    fileprivate func phoneNumberChanged() {
        guard let phone = base.phoneTextField?.text, let code = base.codeTextField?.text, code.count > 1, !phone.isEmpty else {
            base.resultingString = ""
            return
        }

        let string = code + phone

        base.phoneNumberFormatter.number = string

        // determine if entered code is cleared identify by formatter
        if base.phoneNumberFormatter.code == nil || (base.phoneNumberFormatter.code?.count ?? 0) + 1 != code.count {
            base.phoneNumberFormatter.number = ""

            base.resultingString = code + PhoneNumberFormatter.trivialString(from: phone)
            base.phoneTextField?.text = PhoneNumberFormatter.trivialString(from: phone)
        } else {
            base.resultingString = base.phoneNumberFormatter.formatted
            base.phoneTextField?.text = base.resultingString.deletingPrefix(code).deletingLeading(character: " ")
        }

        checkConditions(with: base.phoneNumberFormatter)
    }

    private func checkConditions(with formatter: PhoneNumberFormatter) {
        if let _ = formatter.region {
            switch formatter.isValid {
            case true:
                base.helperTextDelayTimer.fire()
                setHelperTextWithCheck("")
                base.delegate?.phoneNumberComponentSatisfiesAllConditions(base)
            case false:
                let failedCondition = PhoneCondition.phoneLengthMatchesMask

                base.helperTextDelayTimer.addOperation(target: self) {
                    [weak self] in

                    guard let phoneTextField = self?.base.phoneTextField, let text = phoneTextField.text, !text.isEmpty else {
                        self?.setHelperTextWithCheck("")
                        return
                    }

                    self?.setHelperTextWithCheck(failedCondition.rawValue)
                }.fire()

                base.delegate?.phoneNumberComponent(base, dontSatisfyTheCondition: failedCondition)
            }
        } else {
            let failedCondition = PhoneCondition.phoneNumberHaveValidCode

            base.helperTextDelayTimer.addOperation(target: self) {
                [weak self] in

                guard let phoneTextField = self?.base.phoneTextField, let text = phoneTextField.text, !text.isEmpty else {
                    self?.setHelperTextWithCheck("")
                    return
                }

                self?.setHelperTextWithCheck(failedCondition.rawValue)
            }.fire()

            base.delegate?.phoneNumberComponent(base, dontSatisfyTheCondition: failedCondition)
        }
    }

    private enum CountryImageAnimationTask {
        case show(country: String)
        case hide
        case idle
        case change(toCountry: String)

        static func taskFrom(oldCountryNameValue: String?, newCountryNameValue: String?) -> CountryImageAnimationTask {
            if let old = oldCountryNameValue {
                // old is value
                if let new = newCountryNameValue {
                    // old and new are value
                    if old != new {
                        // old and new are value and not equal
                        return .change(toCountry: new)
                    }

                    // old and new are value and equal
                    return .idle
                }
                // old is value, new is nil
                return .hide
            }
            // old is nil
            if let new = newCountryNameValue {
                // old is nil, new is value
                return .show(country: new)
            }
            // old and new is nil
            return .idle
        }
    }

    private func setupCountryImageAnimationWith(state: CountryImageAnimationTask, completion handler: @escaping () -> Void) {
        switch state {
        case .show(country: let country):

            if let flag = Flag(countryCode: country) {
                let image = flag.originalImage
                base.countryImageView?.setImage(image)
            }

            base.textFieldTrailingConstraint?.constant = -16
            base.imageViewLeadingConstraint?.constant = 0

            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                [weak self] in

                self?.base.imageViewLeadingConstraint?.constant = -60
                self?.base.textFieldTrailingConstraint?.constant = -76

                self?.base.layoutIfNeeded()
            }, completion: {
                _ in
                handler()
            })
        case .hide:
            base.textFieldTrailingConstraint?.constant = -76
            base.imageViewLeadingConstraint?.constant = -60

            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                [weak self] in

                self?.base.imageViewLeadingConstraint?.constant = 0
                self?.base.textFieldTrailingConstraint?.constant = -16

                self?.base.layoutIfNeeded()
            }, completion: {
                _ in
                handler()
            })
        case .change(toCountry: let country):
            if let flag = Flag(countryCode: country) {
                let image = flag.originalImage
                base.countryImageView?.setImage(image)
            }
            handler()
        case .idle:
            handler()
        }
    }
}
