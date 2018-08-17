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
    let method: SendMoneyMethod
}

protocol SendMoneyComponentDelegate: class {

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, sendMoneyData: SendMoneyData)
}

class SendMoneyComponent: Component, SendMoneyAmountComponentDelegate, SendMoneyMethodComponentDelegate {

    var userAPI: UserAPI?

    weak var delegate: SendMoneyComponentDelegate?

    @IBOutlet private var sendMoneyMethodComponent: SendMoneyMethodComponent?
    @IBOutlet private var sendMoneyAmountComponent: SendMoneyAmountComponent?
    @IBOutlet private var sendButton: SendMoneyButton?

    @IBOutlet private var topConstraint: NSLayoutConstraint?

    private var balanceData: BalanceData?
    private var method: SendMoneyMethod?

    private var sendMoneyDataProgress: SendMoneyData? {
        guard let method = method, let data = balanceData else {
            return nil
        }

        return SendMoneyData(amountData: data, method: method)
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

    func prepare(coinType: CoinType) {
        sendMoneyAmountComponent?.prepare(coinType: coinType)
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

    func sendMoneyMethodComponent(_ sendMoneyMethodComponent: SendMoneyMethodComponent, methodRecipientDataEntered methodData: SendMoneyMethod) {
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
