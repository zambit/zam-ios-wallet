//
//  PhoneNumberFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import FlagKit

protocol PhoneNumberFormComponentDelegate: class {

    func phoneNumberFormComponentCanChangeHelperText(_ phoneNumberFormComponent: PhoneNumberFormComponent) -> Bool

    func phoneNumberFormComponentEditingChange(_ phoneNumberFormComponent: PhoneNumberFormComponent)

    func phoneNumberFormComponent(_ phoneNumberFormComponent: PhoneNumberFormComponent, dontSatisfyTheCondition: PhoneCondition)

    func phoneNumberFormComponentSatisfiesAllConditions(_ phoneNumberFormComponent: PhoneNumberFormComponent)

}

extension PhoneNumberFormComponentDelegate {

    func phoneNumberFormComponentCanChangeHelperText(_ phoneNumberFormComponent: PhoneNumberFormComponent) -> Bool {
        return true
    }

    func phoneNumberFormComponentEditingChange(_ phoneNumberFormComponent: PhoneNumberFormComponent) { }
}

/**
 Class that controlls entreing phone number form, handles all textFields editing and defines its behaviour.
 */
class PhoneNumberFormComponent: Component, UITextFieldDelegate, PhoneNumberEnteringHandlerDelegate {

    weak var delegate: PhoneNumberFormComponentDelegate?

    /**
     Masks dictionary and parser for using mask
     */
    var masks: [String: PhoneMaskData]?
    var parser: MaskParser?

    /**
     Timer for performing helperText changing with some delay
     */
    private var helperTextDelayTimer: DelayTimer?
    private var helperTextDelayValue: Double = 1.0

    /**
     Entering phone number handler, that's responsible for entering symbols in textFields according phone number format
     */
    private var phoneNumberEnteringHandler: PhoneNumberEnteringHandler?

    @IBOutlet private var detailPhonePartTextField: UITextField?
    @IBOutlet private var mainPhonePartTextField: UITextField?
    @IBOutlet private var countryImageView: CountryView?
    @IBOutlet private var helperTextLabel: UILabel?

    @IBOutlet private var rightLabelsToContentViewConstraint: NSLayoutConstraint?
    @IBOutlet private var rightImageToContentViewConstraint: NSLayoutConstraint?

    @IBOutlet private var textFieldsHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var countryImageViewHeightConstraint: NSLayoutConstraint?

    var helperText: String {
        get {
            return helperTextLabel?.text ?? ""
        }

        set {
            helperTextLabel?.text = newValue
        }
    }

    private var helperTextWithDelegateCheck: String {
        get {
            return helperTextLabel?.text ?? ""
        }

        set {
            if let delegate = delegate, !delegate.phoneNumberFormComponentCanChangeHelperText(self) {
                // do nothing
            } else {
                helperTextLabel?.text = newValue
            }
        }
    }

    var textFieldsHeight: CGFloat {
        get {
            return textFieldsHeightConstraint?.constant ?? 0
        }

        set {
            textFieldsHeightConstraint?.constant = newValue
            layoutIfNeeded()
        }
    }

    var countryImageSide: CGFloat {
        get {
            return countryImageViewHeightConstraint?.constant ?? 0
        }

        set {
            countryImageViewHeightConstraint?.constant = newValue
            layoutIfNeeded()
        }
    }

    /**
     Output concatiated text from detail and main textFields
     */
    var phone: String {
        var result: String = ""

        if let detail = detailPhonePartTextField?.text {
            let numbers = detail.filter {
                "+1234567890 ".contains($0)
            }
            result.append("\(numbers)")
            //result.append(detail)
        }

        if let main = mainPhonePartTextField?.text {
            let numbers = main.filter {
                "1234567890 ".contains($0)
            }
            result.append(" \(numbers)")
            //result.append(main)
        }

        return result
    }

    override func initFromNib() {
        super.initFromNib()

        helperTextDelayTimer = DelayTimer(delay: helperTextDelayValue)

        if let detailTextField = detailPhonePartTextField,
            let numberTextField = mainPhonePartTextField,
            let masks = masks,
            let parser = parser {

            phoneNumberEnteringHandler = PhoneNumberEnteringHandler(codeTextField: detailTextField, numberTextField: numberTextField, masks: masks, maskParser: parser)
            phoneNumberEnteringHandler?.delegate = self
        }
    }

    override func setupStyle() {
        super.setupStyle()

        self.helperTextLabel?.textColor = .error
        self.helperTextLabel?.text = ""

        self.detailPhonePartTextField?.leftPadding = 6.0
        self.mainPhonePartTextField?.leftPadding = 12.0

        self.detailPhonePartTextField?.keyboardType = .decimalPad
        self.mainPhonePartTextField?.keyboardType = .decimalPad

        self.detailPhonePartTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        self.mainPhonePartTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)

        self.detailPhonePartTextField?.font = UIFont.walletFont(ofSize: 20.0, weight: .regular)
        self.mainPhonePartTextField?.font = UIFont.walletFont(ofSize: 20.0, weight: .regular)

        self.detailPhonePartTextField?.textColor = .white
        self.mainPhonePartTextField?.textColor = .white

        self.detailPhonePartTextField?.delegate = self
        self.mainPhonePartTextField?.delegate = self

        self.detailPhonePartTextField?.attributedPlaceholder =
            NSAttributedString(string: "+",
                               attributes: [.font: UIFont.walletFont(ofSize: 20.0, weight: .regular),
                                            .foregroundColor: UIColor.white.withAlphaComponent(0.2)])

        self.countryImageView?.setImage(#imageLiteral(resourceName: "icon_placeholder"))
    }

    func provide(masks: [String: PhoneMaskData], parser: MaskParser, initialCountryCode: String? = nil) {
        self.masks = masks
        self.parser = parser

        guard
            let detailTextField = detailPhonePartTextField,
            let numberTextField = mainPhonePartTextField else {
                return
        }

        phoneNumberEnteringHandler = PhoneNumberEnteringHandler(codeTextField: detailTextField, numberTextField: numberTextField, masks: masks, maskParser: parser)
        phoneNumberEnteringHandler?.delegate = self

        if let code = initialCountryCode {
            phoneNumberEnteringHandler?.explicityHandleCode(code)
        }
    }

    // MARK: - PhoneNumberEnteringHandlerDelegate

    func phoneNumberMaskChanged(_ handler: PhoneNumberEnteringHandler, from oldValue: PhoneMaskData?, to newValue: PhoneMaskData?) {
        let state = CountryImageAnimationTask.taskFrom(
            oldCountryNameValue: oldValue?.countryId,
            newCountryNameValue: newValue?.countryId
        )

        setupCountryImageAnimationWith(state: state) {}
    }

    func phoneNumberEditingChanged(_ handler: PhoneNumberEnteringHandler, with mask: PhoneMaskData?, phoneNumber: String) {
        if let mask = mask {
            switch phoneNumber.count >= mask.phoneMask.count {
            case true:
                helperTextDelayTimer?.fire()
                helperTextWithDelegateCheck = ""
                delegate?.phoneNumberFormComponentSatisfiesAllConditions(self)
            case false:
                let failedCondition = PhoneCondition.phoneLengthMatchesMask

                helperTextDelayTimer?.addOperation {
                    [weak self] in

                    guard phoneNumber != "" else {
                        self?.helperTextWithDelegateCheck = ""
                        return
                    }

                    self?.helperTextWithDelegateCheck = failedCondition.rawValue
                    }.fire()

                delegate?.phoneNumberFormComponent(self, dontSatisfyTheCondition: failedCondition)
            }
        } else {
            let failedCondition = PhoneCondition.phoneNumberHaveValidCode

            helperTextDelayTimer?.addOperation {
                [weak self] in

                guard phoneNumber != "" else {
                    self?.helperTextWithDelegateCheck = ""
                    return
                }

                self?.helperTextWithDelegateCheck = failedCondition.rawValue
                }.fire()

            delegate?.phoneNumberFormComponent(self, dontSatisfyTheCondition: failedCondition)
        }
    }

    /**
     Enum providing different tasks to animate
     */
    enum CountryImageAnimationTask {
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
                countryImageView?.setImage(image)
            }

            rightLabelsToContentViewConstraint?.isActive = false
            rightImageToContentViewConstraint?.isActive = true

            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                [weak self] in

                self?.rightImageToContentViewConstraint?.constant = -20.0
                self?.contentView.layoutIfNeeded()
                }, completion: {
                    [weak self]
                    _ in

                    guard
                        let strongSelf = self,
                        let rightLabel = strongSelf.mainPhonePartTextField else {
                            return
                    }

                    strongSelf.rightLabelsToContentViewConstraint?.isActive = false
                    strongSelf.rightImageToContentViewConstraint?.isActive = true

                    // evaluate new phone label right constraint constant
                    strongSelf.rightLabelsToContentViewConstraint?.constant = rightLabel.frame.origin.x + rightLabel.bounds.width - strongSelf.contentView.bounds.width

                    handler()
            })
        case .hide:
            rightImageToContentViewConstraint?.isActive = false
            rightLabelsToContentViewConstraint?.isActive = true

            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                [weak self] in

                self?.rightLabelsToContentViewConstraint?.constant = 16.0
                self?.contentView.layoutIfNeeded()
                }, completion: {
                    [weak self]
                    _ in

                    guard
                        let strongSelf = self,
                        let imageView = strongSelf.countryImageView else {
                            return
                    }

                    strongSelf.rightImageToContentViewConstraint?.isActive = false
                    strongSelf.rightLabelsToContentViewConstraint?.isActive = true

                    // evaluate new image right constraint constant
                    strongSelf.rightImageToContentViewConstraint?.constant = imageView.frame.origin.x + imageView.bounds.width - strongSelf.contentView.bounds.width

                    handler()
            })
        case .change(toCountry: let country):
            if let flag = Flag(countryCode: country) {
                let image = flag.originalImage
                countryImageView?.setImage(image)
            }
            handler()
        case .idle:
            handler()
        }
    }
}
