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
        case contact(ContactData)
        case phone(String)
    }

    let amountData: BalanceData
    let walletId: String
    let recipient: RecipientType
}

protocol SendMoneyComponentDelegate: class {

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, output: SendingData)
}

class SendMoneyComponent: Component, SizePresetable, SendMoneyAmountComponentDelegate, SegmentedControlComponentDelegate, RecipientComponentDelegate {

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

    private var amountData: BalanceData?
    private var walletId: String?
    private var recipientData: SendingData.RecipientType?

    private var sendingData: SendingData? {
        guard let recipient = recipientData, let amount = amountData, let id = walletId else {
            return nil
        }

        return SendingData(amountData: amount, walletId: id, recipient: recipient)
    }

    override func initFromNib() {
        super.initFromNib()

        segmentedControlComponent?.delegate = self
        sendMoneyAmountComponent?.delegate = self
        recipientComponent?.delegate = self

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

        case .compact, .default:
            topGreaterThanConstraint?.constant = 17.0
            sendButtonHeightConstraint?.constant = 56.0
            recipientTextFieldTopConstraint?.constant = 20.0
            recipientTextFieldHeightConstraint?.constant = 56.0
        }

        layoutIfNeeded()
    }

    func prepare(recipient: FormattedContactData? = nil, coinType: CoinType, walletId: String) {
        self.walletId = walletId
        
        sendMoneyAmountComponent?.prepare(coinType: coinType)

        if let recipient = recipient {
            recipientComponent?.custom.setup(contact: recipient)
        }
    }

    func prepare(address: String, coinType: CoinType, walletId: String) {
        self.walletId = walletId

        sendMoneyAmountComponent?.prepare(coinType: coinType)
        recipientComponent?.custom.setup(address: address)
    }

    // MARK: - SendMoneyAmountComponentDelegate

    func sendMoneyAmountComponent(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amountDataEntered data: BalanceData) {
        self.amountData = data

        if let output = sendingData {
            sendButton?.customAppearance.setEnabled(true)
            sendButton?.customAppearance.provideData(amount: "\(output.amountData.formatted(currency: .original)) \(output.amountData.coin.short.uppercased())", alternative: "")
        }
    }

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent) {
        self.amountData = nil
        sendButton?.customAppearance.setEnabled(false)
    }

    // MARK: - SegmentedControlComponentDelegate

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int) {
        switch index {
        case 0:
            recipientComponent?.custom.showPhone()

            let phone = recipientComponent?.custom.phoneNumber ?? ""
            recipientData = .phone(phone)

            if let output = sendingData {
                sendButton?.customAppearance.setEnabled(true)
                sendButton?.customAppearance.provideData(amount: "\(output.amountData.formatted(currency: .original)) \(output.amountData.coin.short.uppercased())", alternative: "")
            }
        case 1:
            recipientComponent?.custom.showAddress()

            let address = recipientComponent?.custom.address ?? ""
            recipientData = .address(address)

            if let output = sendingData {
                sendButton?.customAppearance.setEnabled(true)
                sendButton?.customAppearance.provideData(amount: "\(output.amountData.formatted(currency: .original)) \(output.amountData.coin.short.uppercased())", alternative: "")
            }
        default:
            return
        }
    }

    // MARK: - RecipientComponentDelegate

    func recipientComponentStatusChanged(_ recipientComponent: RecipientComponent, to status: FormEditingStatus, recipientType: RecipientType) {
        switch recipientType {
        case .address:
            switch status {
            case .valid:
                let address = recipientComponent.custom.address
                recipientData = .address(address)

                if let output = sendingData {
                    sendButton?.customAppearance.setEnabled(true)
                    sendButton?.customAppearance.provideData(amount: "\(output.amountData.formatted(currency: .original)) \(output.amountData.coin.short.uppercased())", alternative: "")
                }
            case .invalid:
                recipientData = nil
                sendButton?.customAppearance.setEnabled(false)
            }
        case .phone:
            switch status {
            case .valid:
                let phone = recipientComponent.custom.phoneNumber
                recipientData = .phone(phone)

                if let output = sendingData {
                    sendButton?.customAppearance.setEnabled(true)
                    sendButton?.customAppearance.provideData(amount: "\(output.amountData.formatted(currency: .original)) \(output.amountData.coin.short.uppercased())", alternative: "")
                }
            case .invalid:
                recipientData = nil
                sendButton?.customAppearance.setEnabled(false)
            }
        }
    }

    // MARK: - TouchEvents

    @objc
    private func sendButtonTouchUpInside(_ sender: Any) {
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
