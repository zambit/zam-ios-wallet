//
//  PhoneNumberFormView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Class that controlls entreing phone number form, handles all textFields editing and defines its behaviour.
 */
class PhoneNumberFormViewController: UIView, UITextFieldDelegate {

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

    /**
     Masks dictionary
     */
    private var masks: [String: [String: String]] = [:]

    /**
      Current mask
     */
    private var currentMask: (String, [String: String])? {
        willSet {
            let state = CountryImageAnimationTask.taskFrom(
                oldCountryNameValue: currentMask?.1["country_name"],
                newCountryNameValue: newValue?.1["country_name"]
            )

            setupCountryImageAnimationWith(state: state) {}
        }
    }

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var detailPhonePartTextField: UITextField?
    @IBOutlet private var mainPhonePartTextField: UITextField?
    @IBOutlet private var countryImageView: CountryView?

    @IBOutlet private var rightLabelsToContentViewConstraint: NSLayoutConstraint?
    @IBOutlet private var rightImageToContentViewConstraint: NSLayoutConstraint?

    /**
     Output concatiated text from detail and main textFields
     */
    var text: String {
        var result: String = ""

        if let detail = detailPhonePartTextField?.text {
            let numbers = detail.filter {
                "1234567890".contains($0)
            }
            result.append("\(numbers)")
        }

        if let main = mainPhonePartTextField?.text {
            let numbers = main.filter {
                "1234567890".contains($0)
            }
            result.append("\(numbers)")
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

        detailPhonePartTextField?.addTarget(self, action: #selector(detailTextFieldEditingEnd(_:)), for: .editingDidEnd)
        detailPhonePartTextField?.addTarget(self, action: #selector(detailTextFieldEditingBegin(_:)), for: .editingDidBegin)
        detailPhonePartTextField?.addTarget(self, action: #selector(detailTextFieldEditingChanged(_:)), for: .editingChanged)

        mainPhonePartTextField?.addTarget(self, action: #selector(mainTextFieldEditingEnd(_:)), for: .editingDidEnd)
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.detailPhonePartTextField?.keyboardType = .phonePad
        self.mainPhonePartTextField?.keyboardType = .decimalPad

        self.detailPhonePartTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        self.mainPhonePartTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)

        self.detailPhonePartTextField?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        self.mainPhonePartTextField?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)

        self.detailPhonePartTextField?.textColor = .white
        self.mainPhonePartTextField?.textColor = .white

        self.detailPhonePartTextField?.delegate = self
        self.mainPhonePartTextField?.delegate = self

        self.countryImageView?.setImage(#imageLiteral(resourceName: "icon_placeholder"))
    }

    func provideDictionaryOfMasks(_ masks: [String: [String: String]]) {
        self.masks = masks
    }

    // - UITextField events handlers
    @objc
    private func detailTextFieldEditingBegin(_ sender: UITextField) {
        sender.text?.addPrefixIfNeeded("+")
    }

    @objc
    private func detailTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        sender.text?.addPrefixIfNeeded("+")

        currentMask = masks.filter {
            "+\($0.key)" == text
        }.first
    }

    @objc
    private func detailTextFieldEditingEnd(_ sender: UITextField) {
        sender.resignFirstResponder()
        sender.layoutIfNeeded()
    }

    @objc
    private func mainTextFieldEditingEnd(_ sender: UITextField) {
        sender.resignFirstResponder()
        sender.layoutIfNeeded()
    }

    // - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let detailTextField = detailPhonePartTextField, textField == detailPhonePartTextField {
            return detailTextFieldShouldChangeCharactersIn(range: range, replacementString: string, textField: detailTextField)
        }

        if textField == mainPhonePartTextField {
            return mainTextFieldShouldChangeCharactersIn(range: range, replacementString: string)
        }

        return true
    }

    private func detailTextFieldShouldChangeCharactersIn(range: NSRange, replacementString string: String, textField: UITextField) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    private func mainTextFieldShouldChangeCharactersIn(range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)

        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }

        guard let text = mainPhonePartTextField?.text else {
            return true
        }

        if let textRange = Range(range, in: text),
            let mask = currentMask?.1["phone_mask"] {

            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let maskedText = matching(text: updatedText, withMask: mask)

            mainPhonePartTextField?.text = maskedText
            return false
        }

        return true
    }

    private func matching(text: String, withMask mask: String) -> String {

        var resulting: String = ""
        var textIndex: Int = 0

        for character in mask {
            if !(textIndex < text.count) {
                return resulting
            }

            switch character {
            case " ":
                resulting.append(" ")

                if text[textIndex] == " " {
                    textIndex += 1
                }

            case "X":
                if text[textIndex] != " " {
                    resulting.append(text[textIndex])
                }

                textIndex += 1

            default:
                fatalError()
            }
        }

        if resulting.count < text.count {
            let remained = text[resulting.count..<text.count]
            resulting.append(contentsOf: remained)
        }

        return resulting
    }

    private func setupCountryImageAnimationWith(state: CountryImageAnimationTask, completion handler: @escaping () -> Void) {

        switch state {
        case .show(country: let country):
            rightLabelsToContentViewConstraint?.isActive = false
            rightImageToContentViewConstraint?.isActive = true

            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
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

                    // evaluate new phone label right constraint constant
                    strongSelf.rightLabelsToContentViewConstraint?.constant = rightLabel.frame.origin.x + rightLabel.bounds.width - strongSelf.contentView.bounds.width

                    handler()
            })
        case .hide:
            rightImageToContentViewConstraint?.isActive = false
            rightLabelsToContentViewConstraint?.isActive = true

            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
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

                    // evaluate new image right constraint constant
                    strongSelf.rightImageToContentViewConstraint?.constant = imageView.frame.origin.x + imageView.bounds.width - strongSelf.contentView.bounds.width

                    handler()
            })
        case .change(toCountry: let country):
            handler()
        case .idle:
            handler()
        }
    }
}
