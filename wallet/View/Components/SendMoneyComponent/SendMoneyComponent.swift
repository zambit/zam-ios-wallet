//
//  SendMoneyComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct SendingData {

    enum RecipientType {
        case address(String)
        case contact(name: String, phone: String)
        case phone(String)
    }

    let amount: Amount
    let walletId: String
    let recipient: RecipientType
}

protocol SendMoneyComponentDelegate: class {

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, output: SendingData)
}

class SendMoneyComponent: Component, SizePresetable {

    var onQRCodeScanning: (() -> Void)?

    weak var delegate: SendMoneyComponentDelegate?

    @IBOutlet private var toLabel: UILabel?
    @IBOutlet private var segmentedControlComponent: SegmentedControlComponent?
    @IBOutlet private var recipientComponent: RecipientComponent?

    @IBOutlet private var sendMoneyAmountComponent: SendMoneyAmountComponent?
    @IBOutlet private var sendButton: SendMoneyButton?

    @IBOutlet private var topGreaterThanConstraint: NSLayoutConstraint?
    @IBOutlet private var sendButtonHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var recipientTextFieldTopConstraint: NSLayoutConstraint?
    @IBOutlet private var recipientTextFieldHeightConstraint: NSLayoutConstraint?

    private var amountData: Amount?
    private var walletId: String?
    private var recipientData: SendingData.RecipientType?

    private var sendingData: SendingData? {
        guard let recipient = recipientData, let amount = amountData, let id = walletId else {
            return nil
        }

        return SendingData(amount: amount, walletId: id, recipient: recipient)
    }

    override func initFromNib() {
        super.initFromNib()

        segmentedControlComponent?.delegate = self
        sendMoneyAmountComponent?.delegate = self
        recipientComponent?.delegate = self

        segmentedControlComponent?.segmentsHorizontalMargin = 15.0
        segmentedControlComponent?.segmentsHorizontalSpacing = 5.0

        switch UIScreen.main.type {
        case .extraSmall, .small:
            segmentedControlComponent?.alignment = .left
            if let label = toLabel {
                segmentedControlComponent?.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10.0).isActive = true
            }
        case .medium, .plus, .extra, .extraLarge:
            segmentedControlComponent?.alignment = .center
            segmentedControlComponent?.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0.0).isActive = true
        case .unknown:
            fatalError()
        }

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "phoneOutgoing"), title: "Phone", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .paleOliveGreen)
        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "linkTo"), title: "Address", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .lightblue)

        recipientComponent?.custom.addRightDetailButtonTouchUpInsideEvent(target: self, action: #selector(scanQRAddressWithCamera(_:)))

        sendButton?.addTarget(self, action: #selector(sendButtonTouchUpInside(_:)), for: .touchUpInside)
    }

    override func setupStyle() {
        super.setupStyle()

        backgroundColor = .white

        toLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        toLabel?.textColor = .darkIndigo
        toLabel?.text = "To"
    }

    func prepare(preset: SizePreset) {
        sendMoneyAmountComponent?.prepare(preset: preset)

        switch preset {
        case .superCompact:
            topGreaterThanConstraint?.constant = 10.0
            sendButtonHeightConstraint?.constant = 44.0
            recipientTextFieldTopConstraint?.constant = 10.0
            recipientTextFieldHeightConstraint?.constant = 50.0

        case .compact, .default, .large:
            topGreaterThanConstraint?.constant = 17.0
            sendButtonHeightConstraint?.constant = 56.0
            recipientTextFieldTopConstraint?.constant = 20.0
            recipientTextFieldHeightConstraint?.constant = 56.0
        }

        layoutIfNeeded()
    }

    func prepare(recipient: FormattedContact? = nil, coinType: CoinType, walletId: String, coinPrice: CoinPrice? = nil) {
        self.walletId = walletId
        
        sendMoneyAmountComponent?.prepare(coinType: coinType)
        updateSendingData(for: coinType)

        if let recipient = recipient {
            recipientComponent?.custom.setup(contact: recipient)
            updateSendingData(for: .phone)
        }

        sendMoneyAmountComponent?.prepare(coinPrice: coinPrice)
    }

    func prepare(address: String, coinType: CoinType, walletId: String, coinPrice: CoinPrice? = nil) {
        self.walletId = walletId

        sendMoneyAmountComponent?.prepare(coinType: coinType)
        updateSendingData(for: coinType)

        recipientComponent?.custom.setup(address: address)
        updateSendingData(for: .address)

        sendMoneyAmountComponent?.prepare(coinPrice: coinPrice)
    }

    func prepare(coinPrice: CoinPrice) {
        sendMoneyAmountComponent?.prepare(coinPrice: coinPrice)
    }

    private func updateSendButton(with amountData: Amount) {

        var detail: String? = nil

        if let detailValue = amountData.fiatValue {
            detail = "\(detailValue.shortFormatted ?? "") \(amountData.fiat.symbol)"
        }

        sendButton?.custom.provide(amount: "\(amountData.value.longFormatted ?? "") \(amountData.coin.short.uppercased())",
            detail: detail)
    }

    // MARK: - Update sending data

    private func updateSendingData(for coinType: CoinType) {
        guard let amountData = amountData else {
            return
        }

        self.amountData = Amount(value: amountData.value, coin: coinType, fiat: amountData.fiat, coinPrice: nil)

        if let output = sendingData {
            updateSendButton(with: output.amount)
        }
    }

    private func updateSendingData(for recipientType: RecipientType) {
        switch recipientType {
        case .phone:
            guard let phone = recipientComponent?.custom.phoneNumber, !phone.isEmpty else {
                recipientData = nil
                return
            }

            if let name = recipientComponent?.custom.recipientName {
                recipientData = .contact(name: name, phone: phone)
            } else {
                recipientData = .phone(phone)
            }

            if let output = sendingData {
                updateSendButton(with: output.amount)
            }
        case .address:
            guard let address = recipientComponent?.custom.address, !address.isEmpty else {
                recipientData = nil
                return
            }

            recipientData = .address(address)

            if let output = sendingData {
                updateSendButton(with: output.amount)
            }
        }
    }

    // MARK: - TouchEvents

    @objc
    private func sendButtonTouchUpInside(_ sender: Any) {
        guard let index = segmentedControlComponent?.currentIndex else {
            return
        }

        switch index {
        case 0:
            updateSendingData(for: .phone)
        case 1:
            updateSendingData(for: .address)
        default:
            return
        }

        guard let output = sendingData else {
            return
        }

        delegate?.sendMoneyComponentRequestSending(self, output: output)
    }

    @objc
    private func scanQRAddressWithCamera(_ sender: Any) {
        onQRCodeScanning?()
    }
}

extension SendMoneyComponent: SendMoneyAmountComponentDelegate {

    func sendMoneyAmountComponentEditingChanged(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amount: Amount) {
        self.amountData = amount

        if let output = sendingData {
            updateSendButton(with: output.amount)
        }
    }

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent) {
        self.amountData = nil
        sendButton?.custom.isEnabled = false
    }
}

extension SendMoneyComponent: SegmentedControlComponentDelegate {

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int) {
        switch index {
        case 0:
            recipientComponent?.custom.showPhone()
            updateSendingData(for: .phone)
        case 1:
            recipientComponent?.custom.showAddress()
            updateSendingData(for: .address)
        default:
            return
        }
    }
}

extension SendMoneyComponent: RecipientComponentDelegate {

    func recipientComponentStatusChanged(_ recipientComponent: RecipientComponent, to status: FormEditingStatus, recipientType: RecipientType) {
        switch status {
        case .valid:
            updateSendingData(for: recipientType)
        case .invalid:
            recipientData = nil
            sendButton?.custom.isEnabled = false
        }
    }
}
