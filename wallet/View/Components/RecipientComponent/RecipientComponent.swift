//
//  RecipientComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 19/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

enum DisplayState {
    case disappeared
    case appeared

    mutating func toggle() {
        switch self {
        case .appeared:
            self = .disappeared
        case .disappeared:
            self = .appeared
        }
    }
}

enum RecipientType {
    case phone
    case address
}

protocol RecipientComponentDelegate: class {

    func recipientComponentStatusChanged(_ recipientComponent: RecipientComponent, to status: FormEditingStatus, recipientType: RecipientType)
}

class RecipientComponent: UIView, PhoneNumberRecipientComponentDelegate, AddressRecipientComponentDelegate {

    weak var delegate: RecipientComponentDelegate?

    fileprivate var phoneRecipientComponent: PhoneNumberRecipientComponent?
    fileprivate var addressRecipientComponent: AddressRecipientComponent?

    private(set) var isEditing: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setup()
    }

    // MARK: - AddressRecipientComponentDelegate

    func addressRecipientComponentStatusChanged(_ addressRecipientComponent: AddressRecipientComponent, to status: FormEditingStatus) {
        delegate?.recipientComponentStatusChanged(self, to: status, recipientType: .address)
    }

    // MARK: - PhoneNumberRecipientComponentDelegate

    func phoneNumberRecipientComponentStatusChanged(_ phoneNumberRecipientComponent: PhoneNumberRecipientComponent, to status: FormEditingStatus) {
        delegate?.recipientComponentStatusChanged(self, to: status, recipientType: .phone)
    }
}

extension BehaviorExtension where Base: RecipientComponent {

    var recipientName: String? {
        return base.phoneRecipientComponent?.custom.name
    }

    var phoneNumber: String {
        return base.phoneRecipientComponent?.custom.phone ?? ""
    }

    var address: String {
        return base.addressRecipientComponent?.custom.address ?? ""
    }

    func setup(address: String) {
        base.addressRecipientComponent?.custom.setup(address: address)
    }

    func setup(contact: FormattedContact) {
        base.phoneRecipientComponent?.custom.setup(contact: contact)
    }

    func showPhone() {
        let isEditing = base.addressRecipientComponent?.custom.isEditing ?? false
        base.phoneRecipientComponent?.custom.set(state: .appeared, animation: {
            [weak self]
            _ in

            self?.base.backgroundColor = .paleOliveGreen
        })
        base.addressRecipientComponent?.custom.set(state: .disappeared)

        if isEditing {
            base.phoneRecipientComponent?.custom.beginEditing()
        }
        base.addressRecipientComponent?.isUserInteractionEnabled = false
    }

    func showAddress() {
        let isEditing = base.phoneRecipientComponent?.custom.isEditing ?? false
        base.addressRecipientComponent?.custom.set(state: .appeared, animation: {
            [weak self]
            view in

            self?.base.backgroundColor = .lightblue
            view.isUserInteractionEnabled = true
        })
        base.phoneRecipientComponent?.custom.set(state: .disappeared)

        if isEditing {
            base.addressRecipientComponent?.custom.beginEditing()
        }
    }

    func addRightDetailButtonTouchUpInsideEvent(target: Any?, action: Selector) {
        base.addressRecipientComponent?.custom.addDetailButtonTouchUpInsideEvent(target: target, action: action)
    }

    fileprivate func setup() {
        setupSubviews()
        setupInitialState()
    }

    fileprivate func setupSubviews() {
        base.viewWithTag(16831513)?.removeFromSuperview()
        base.viewWithTag(1441831513)?.removeFromSuperview()

        let phoneRecipientComponent = PhoneNumberRecipientComponent(frame: base.bounds)
        phoneRecipientComponent.tag = 16831513
        phoneRecipientComponent.delegate = base

        base.addSubview(phoneRecipientComponent)

        phoneRecipientComponent.translatesAutoresizingMaskIntoConstraints = false

        phoneRecipientComponent.leadingAnchor.constraint(equalTo: base.leadingAnchor).isActive = true
        phoneRecipientComponent.trailingAnchor.constraint(equalTo: base.trailingAnchor).isActive = true
        phoneRecipientComponent.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        phoneRecipientComponent.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true

        base.phoneRecipientComponent = phoneRecipientComponent


        let addressRecipientComponent = AddressRecipientComponent(frame: base.bounds)
        addressRecipientComponent.tag = 1441831513
        addressRecipientComponent.delegate = base

        base.addSubview(addressRecipientComponent)

        addressRecipientComponent.translatesAutoresizingMaskIntoConstraints = false

        addressRecipientComponent.leadingAnchor.constraint(equalTo: base.leadingAnchor).isActive = true
        addressRecipientComponent.trailingAnchor.constraint(equalTo: base.trailingAnchor).isActive = true
        addressRecipientComponent.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        addressRecipientComponent.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true

        base.addressRecipientComponent = addressRecipientComponent

        base.layoutIfNeeded()
    }

    fileprivate func setupInitialState() {
        base.phoneRecipientComponent?.custom.set(state: .appeared, animation: {
            [weak self]
            _ in

            self?.base.backgroundColor = .paleOliveGreen
            self?.base.addressRecipientComponent?.isUserInteractionEnabled = false
        })
        base.addressRecipientComponent?.custom.set(state: .disappeared)
    }
}
