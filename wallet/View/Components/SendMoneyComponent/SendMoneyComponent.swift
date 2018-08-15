//
//  SendMoneyComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyComponent: Component, SendMoneyAmountComponentDelegate {

    var userAPI: UserAPI?

    @IBOutlet private var sendMoneyMethodComponent: SendMoneyMethodComponent?
    @IBOutlet private var sendMoneyAmountComponent: SendMoneyAmountComponent?
    @IBOutlet private var sendButton: SendMoneyButton?

    private var coinType: CoinType? = .btc

    override func initFromNib() {
        super.initFromNib()

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

        sendMoneyAmountComponent?.delegate = self

        if let coin = coinType {
            sendMoneyAmountComponent?.prepare(coinType: coin)
        }
    }

    override func setupStyle() {
        super.setupStyle()
    }

    func prepare(coinType: CoinType) {
        self.coinType = coinType
    }

    func sendMoneyAmountComponent(_ sendMoneyAmountComponent: SendMoneyAmountComponent, valueCorrectlyEntered value: String, detailValue: String) {
        sendButton?.customAppearance.setEnabled(true)
        sendButton?.customAppearance.provideData(amount: value, alternative: detailValue)
    }

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent) {
        sendButton?.customAppearance.setEnabled(false)
    }
}
