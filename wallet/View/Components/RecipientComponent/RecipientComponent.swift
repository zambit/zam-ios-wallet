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

    var inverted: DisplayState {
        switch self {
        case .appeared:
            return .disappeared
        case .disappeared:
            return .appeared
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setup()
    }

    func addressRecipientComponentStatusChanged(_ addressRecipientComponent: AddressRecipientComponent, to status: FormEditingStatus) {
        delegate?.recipientComponentStatusChanged(self, to: status, recipientType: .address)
    }

    func phoneNumberRecipientComponentStatusChanged(_ phoneNumberRecipientComponent: PhoneNumberRecipientComponent, to status: FormEditingStatus) {
        delegate?.recipientComponentStatusChanged(self, to: status, recipientType: .phone)
    }
}

extension BehaviorExtension where Base: RecipientComponent {

    var phoneNumber: String {
        return base.phoneRecipientComponent?.custom.phone ?? ""
    }

    var address: String {
        return base.addressRecipientComponent?.custom.address ?? ""
    }

    func turnLeft() {
        base.phoneRecipientComponent?.custom.set(state: .appeared, animation: {
            [weak self]
            _ in

            self?.base.backgroundColor = .paleOliveGreen
            self?.base.addressRecipientComponent?.isUserInteractionEnabled = false
        })
        base.addressRecipientComponent?.custom.set(state: .disappeared)
    }

    func turnRight() {
        base.addressRecipientComponent?.custom.set(state: .appeared, animation: {
            [weak self]
            view in

            self?.base.backgroundColor = .lightblue
            view.isUserInteractionEnabled = true
        })
        base.phoneRecipientComponent?.custom.set(state: .disappeared)
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
