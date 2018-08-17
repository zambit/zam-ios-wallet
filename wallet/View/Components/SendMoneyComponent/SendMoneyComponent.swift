//
//  SendMoneyComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct SendMoneyDataProgress {
    let amount: Decimal
    let amountString: String
    let method: SendMoneyMethod
}

class SendMoneyComponent: Component, SendMoneyAmountComponentDelegate, SendMoneyMethodComponentDelegate {

    var userAPI: UserAPI?

    @IBOutlet private var sendMoneyMethodComponent: SendMoneyMethodComponent?
    @IBOutlet private var sendMoneyAmountComponent: SendMoneyAmountComponent?
    @IBOutlet private var sendButton: SendMoneyButton?

    @IBOutlet private var topConstraint: NSLayoutConstraint?

    var appearingAnimationBlock: () -> Void {
        return {
            [weak self] in
            self?.topConstraint?.constant = 36.0
        }
    }

    var disappearingAnimationBlock: () -> Void {
        return {
            [weak self] in
            self?.topConstraint?.constant = 58.0
        }
    }

    private var amountString: String?
    private var amount: Decimal?
    private var method: SendMoneyMethod?

    private var sendMoneyDataProgress: SendMoneyDataProgress? {
        guard let method = method, let amount = amount, let amountString = amountString else {
            return nil
        }

        return SendMoneyDataProgress(amount: amount, amountString: amountString, method: method)
    }

    override func initFromNib() {
        super.initFromNib()

        sendMoneyAmountComponent?.delegate = self
        sendMoneyMethodComponent?.delegate = self

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

    func sendMoneyAmountComponent(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amountValueEntered value: Decimal, stringFormat: String) {
        self.amount = value
        self.amountString = stringFormat

        if let progressData = sendMoneyDataProgress {
            sendButton?.customAppearance.setEnabled(true)
            sendButton?.customAppearance.provideData(amount: progressData.amountString, alternative: "")
        }
    }

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent) {
        self.amount = nil
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
            sendButton?.customAppearance.provideData(amount: progressData.amountString, alternative: "")
        }
    }

    func sendMoneyMethodComponentRecipientDataInvalid(_ sendMoneyMethodComponent: SendMoneyMethodComponent) {
        self.method = nil
        sendButton?.customAppearance.setEnabled(false)
    }
}
