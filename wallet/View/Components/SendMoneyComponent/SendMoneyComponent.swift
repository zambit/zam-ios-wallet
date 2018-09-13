//
//  SendMoneyComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct SendMoneyData {
    let amountData: BalanceData
    let method: SendMoneyMethod.Data
    let walletId: String
}

protocol SendMoneyComponentDelegate: class {

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, sendMoneyData: SendMoneyData)
}

class SendMoneyComponent: Component, SizePresetable, SendMoneyAmountComponentDelegate, SendMoneyMethodComponentDelegate {

    var onQRCodeScanning: (() -> Void)? {
        didSet {
            sendMoneyMethodComponent?.onRightDetail = onQRCodeScanning
        }
    }

    var userAPI: UserAPI?

    weak var delegate: SendMoneyComponentDelegate?

    @IBOutlet private var sendMoneyMethodComponent: SendMoneyMethodComponent?
    @IBOutlet private var sendMoneyAmountComponent: SendMoneyAmountComponent?
    @IBOutlet private var sendButton: SendMoneyButton?

    @IBOutlet private var topGreaterThanConstraint: NSLayoutConstraint?
    @IBOutlet private var sendButtonHeightConstraint: NSLayoutConstraint?

    private var balanceData: BalanceData?
    private var method: SendMoneyMethod.Data?
    private var walletId: String?

    private var sendMoneyDataProgress: SendMoneyData? {
        guard let method = method, let data = balanceData, let id = walletId else {
            return nil
        }

        return SendMoneyData(amountData: data, method: method, walletId: id)
    }

    override func initFromNib() {
        super.initFromNib()

        sendMoneyAmountComponent?.delegate = self
        sendMoneyMethodComponent?.delegate = self

        sendButton?.addTarget(self, action: #selector(sendButtonTouchUpInside(_:)), for: .touchUpInside)

        // Add dictionary with phone codes to appropriate PhoneNumberFormView
        guard let path = Bundle.main.path(forResource: "PhoneMasks", ofType: "plist"),
            let masksDictionary = NSDictionary(contentsOfFile: path) as? [String: [String: String]] else {
                fatalError("PhoneMasks.plist error")
        }

        // Convert dictionary of mask to appropriate format
        do {
            let phoneMasks = try masksDictionary.mapValues {
                return try PhoneMaskData(dictionary: $0)
            }

            sendMoneyMethodComponent?.provide(phoneMasks: phoneMasks, parser: MaskParser(symbol: "X", space: " "))
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }

    override func setupStyle() {
        super.setupStyle()

        backgroundColor = .white
    }


    func prepare(preset: SizePreset) {
        sendMoneyAmountComponent?.prepare(preset: preset)
        sendMoneyMethodComponent?.prepare(preset: preset)

        switch preset {
        case .superCompact:
            topGreaterThanConstraint?.constant = 10.0
            sendButtonHeightConstraint?.constant = 44.0
        case .compact, .default:
            topGreaterThanConstraint?.constant = 17.0
            sendButtonHeightConstraint?.constant = 56.0
        }

        layoutIfNeeded()
    }

    func prepare(recipient: ContactData? = nil, coinType: CoinType, walletId: String) {
        self.walletId = walletId
        
        sendMoneyAmountComponent?.prepare(coinType: coinType)

        if let recipient = recipient {
            sendMoneyMethodComponent?.prepare(recipient: recipient)
        }
    }

    func prepare(address: String, coinType: CoinType, walletId: String) {
        self.walletId = walletId

        sendMoneyAmountComponent?.prepare(coinType: coinType)
        sendMoneyMethodComponent?.prepare(address: address)
    }

    // MARK: - SendMoneyAmountComponentDelegate

    func sendMoneyAmountComponent(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amountDataEntered data: BalanceData) {
        self.balanceData = data

        if let progressData = sendMoneyDataProgress {
            sendButton?.customAppearance.setEnabled(true)
            sendButton?.customAppearance.provideData(amount: "\(progressData.amountData.formatted(currency: .original)) \(progressData.amountData.coin.short.uppercased())", alternative: "")
        }
    }

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent) {
        self.balanceData = nil
        sendButton?.customAppearance.setEnabled(false)
    }

    // MARK: - SendMoneyMethodComponentDelegate

    func sendMoneyMethodSelected(_ sendMoneyMethodComponent: SendMoneyMethodComponent, method: SendMoneyMethod) {
        //...
    }

    func sendMoneyMethodComponent(_ sendMoneyMethodComponent: SendMoneyMethodComponent, methodRecipientDataEntered methodData: SendMoneyMethod.Data) {
        self.method = methodData

        if let progressData = sendMoneyDataProgress {
            sendButton?.customAppearance.setEnabled(true)
            sendButton?.customAppearance.provideData(amount: "\(progressData.amountData.formatted(currency: .original)) \(progressData.amountData.coin.short.uppercased())", alternative: "")
        }
    }

    func sendMoneyMethodComponentRecipientDataInvalid(_ sendMoneyMethodComponent: SendMoneyMethodComponent) {
        self.method = nil
        sendButton?.customAppearance.setEnabled(false)
    }

    @objc
    private func sendButtonTouchUpInside(_ sender: Any) {
        guard let data = sendMoneyDataProgress else {
            return
        }

        delegate?.sendMoneyComponentRequestSending(self, sendMoneyData: data)
    }
}
