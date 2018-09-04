//
//  SendMoneyWayChoosingComponent.swift
//  wallet
//
//  Created by  me on 15/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

enum SendMoneyMethod {
    case phone
    case address

    enum Data {
        case phone(data: String)
        case address(data: String)
    }
}

protocol SendMoneyMethodComponentDelegate: class {

    func sendMoneyMethodSelected(_ sendMoneyMethodComponent: SendMoneyMethodComponent, method: SendMoneyMethod)

    func sendMoneyMethodComponent(_ sendMoneyMethodComponent: SendMoneyMethodComponent, methodRecipientDataEntered methodData: SendMoneyMethod.Data)

    func sendMoneyMethodComponentRecipientDataInvalid(_ sendMoneyMethodComponent: SendMoneyMethodComponent)

}

class SendMoneyMethodComponent: Component, SegmentedControlComponentDelegate, PhoneNumberEnteringHandlerDelegate, IconableTextFieldDelegate {

    var onRightDetail: (() -> Void)?

    weak var delegate: SendMoneyMethodComponentDelegate?

    @IBOutlet private var toLabel: UILabel?
    @IBOutlet private var segmentedControlComponent: SegmentedControlComponent?
    @IBOutlet private var recipientTextField: IconableTextField?

    private var phoneNumberEnteringHandler: PhoneNumberEnteringHandler?

    private var phoneMasks: [String: PhoneMaskData]?
    private var parser: MaskParser?

    private var phone: String = ""
    private var address: String = ""

    override func initFromNib() {
        super.initFromNib()

        recipientTextField?.iconableDelegate = self

        segmentedControlComponent?.delegate = self

        segmentedControlComponent?.segmentsHorizontalMargin = 15.0
        segmentedControlComponent?.segmentsHorizontalSpacing = 5.0

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            segmentedControlComponent?.alignment = .left
            if let label = toLabel {
                segmentedControlComponent?.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10.0).isActive = true
            }
        case .medium, .plus, .extra:
            segmentedControlComponent?.alignment = .center
            segmentedControlComponent?.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0.0).isActive = true
        default:
            fatalError()
        }

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "phoneOutgoing"), title: "Phone", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .paleOliveGreen)
        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "linkTo"), title: "Address", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .lightblue)
    }

    override func setupStyle() {
        super.setupStyle()

        toLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        toLabel?.textColor = .darkIndigo

        recipientTextField?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        recipientTextField?.textAlignment = .center
        recipientTextField?.textColor = .white
        recipientTextField?.tintColor = .white
        recipientTextField?.backgroundColor = .warmGrey
    }

    func provide(phoneMasks: [String: PhoneMaskData], parser: MaskParser) {
        self.phoneMasks = phoneMasks
        self.parser = parser

        if let textField = recipientTextField {
            setPhoneNumberStyleForRecipientTextField(textField, backgroundColor: .paleOliveGreen, masks: phoneMasks, parser: parser)
        }
    }

    func prepare(recipient: ContactData) {
        phoneNumberEnteringHandler?.explicityHandleNumber(recipient.phoneNumbers.first!)
    }

    func prepare(address: String) {
        segmentedControlComponent?.selectElement(withIndex: 1)
        recipientTextField?.setText(address)

        self.address = address
        delegate?.sendMoneyMethodComponent(self, methodRecipientDataEntered: .address(data: address))
    }

    // MARK: - Switching detail mode recipientTextField methods

    private func setPhoneNumberStyleForRecipientTextField(_ textField: IconableTextField, backgroundColor: UIColor, masks: [String: PhoneMaskData], parser: MaskParser) {
        textField.endEditing(true)
        textField.detailMode = .left(detailImage: #imageLiteral(resourceName: "users"), detailImageTintColor: .paleOliveGreen, imageOffset: 8.0)
        textField.backgroundColor = backgroundColor
        textField.keyboardType = .phonePad
        textField.text = ""
        textField.attributedPlaceholder =
            NSAttributedString(string: "Phone number",
                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        phoneNumberEnteringHandler = PhoneNumberEnteringHandler(textField: textField, masks: masks, maskParser: parser)
        phoneNumberEnteringHandler?.delegate = self

        if !phone.isEmpty {
            phoneNumberEnteringHandler?.explicityHandleNumber(phone)
        }
    }

    private func setAddressStyleForRecipientTextField(_ textField: IconableTextField, backgroundColor: UIColor) {
        textField.endEditing(true)
        textField.detailMode = .right(detailImage: #imageLiteral(resourceName: "maximize"), detailImageTintColor: .white, imageOffset: 8.0)
        textField.backgroundColor = backgroundColor
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.text = ""
        textField.attributedPlaceholder =
            NSAttributedString(string: "Address",
                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        phoneNumberEnteringHandler = nil
    }

    // MARK: - SegmentedControlComponentDelegate

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int, withAnimatedDuration: Float, color: UIColor) {

        switch index {
        case 0:
            guard let textField = recipientTextField, let masks = phoneMasks, let parser = parser else { return }
            setPhoneNumberStyleForRecipientTextField(textField, backgroundColor: color, masks: masks, parser: parser)

            delegate?.sendMoneyMethodSelected(self, method: .phone)

        case 1:
            guard let textField = recipientTextField else { return }
            setAddressStyleForRecipientTextField(textField, backgroundColor: color)

            delegate?.sendMoneyMethodSelected(self, method: .address)
        default:
            fatalError()
        }
    }

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int, color: UIColor) {
    }

    // MARK: - PhoneNumberEnteringHandlerDelegate

    func phoneNumberMaskChanged(_ handler: PhoneNumberEnteringHandler, from oldValue: PhoneMaskData?, to newValue: PhoneMaskData?) {
    }

    func phoneNumberEditingChanged(_ handler: PhoneNumberEnteringHandler, with mask: PhoneMaskData?, phoneNumber: String) {
        self.phone = phoneNumber

        if let mask = mask, phoneNumber.count >= mask.phoneMask.count + mask.phoneCode.count + 2 {
            delegate?.sendMoneyMethodComponent(self, methodRecipientDataEntered: .phone(data: phoneNumber))
        } else {
            delegate?.sendMoneyMethodComponentRecipientDataInvalid(self)
        }
    }

    // MARK: - TextFieldEnteringHandler

    func iconableTextFieldEditingChanged(_ iconableTextField: IconableTextField, currentDetailMode: IconableTextField.DetailMode) {
        switch currentDetailMode {
        case .left:
            break
        case .right:
            self.address = iconableTextField.text ?? ""

            if let address = iconableTextField.text, !address.isEmpty {
                delegate?.sendMoneyMethodComponent(self, methodRecipientDataEntered: .address(data: address))
            } else {
                delegate?.sendMoneyMethodComponentRecipientDataInvalid(self)
            }
        case .empty:
            break
        }
    }

    // MARK: - IconableTextFieldDelegate

    func iconableTextFieldOnRightDetailTapEvent(_ iconableTextField: IconableTextField) {
        onRightDetail?()
    }
}
