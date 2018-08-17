//
//  SendMoneyAmountComponent.swift
//  wallet
//
//  Created by  me on 15/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol SendMoneyAmountComponentDelegate: class {

    func sendMoneyAmountComponent(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amountDataEntered data: BalanceData)

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent)

}

class SendMoneyAmountComponent: Component, UITextFieldDelegate {

    weak var delegate: SendMoneyAmountComponentDelegate?
    
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var valueTextField: UITextField?
    @IBOutlet private var altValueLabel: UILabel?

    @IBOutlet private var feeContainer: UIView?

    @IBOutlet private var blockchainFee: IndentLabel?
    @IBOutlet private var zamzamFee: IndentLabel?

    private var coin: CoinType?

    private var coinPrefix: String {
        if let coin = coin {
            return "\(coin.short.uppercased())"
        }

        return ""
    }

    private(set) var amount: Decimal = 0.0
    private(set) var detail: Float = 0

    override func initFromNib() {
        super.initFromNib()

        valueTextField?.delegate = self
        valueTextField?.addTarget(self, action: #selector(valueTextFieldEditingChanged(_:)), for: .editingChanged)
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .warmGrey
        titleLabel?.text = "Amount"

        valueTextField?.font = UIFont.walletFont(ofSize: 46.0, weight: .regular)
        valueTextField?.textAlignment = .center
        valueTextField?.textColor = .darkIndigo
        valueTextField?.tintColor = .darkIndigo
        valueTextField?.keyboardType = .decimalPad
        valueTextField?.attributedPlaceholder =
            NSAttributedString(string: "0.0", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkIndigo])

        altValueLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        altValueLabel?.textAlignment = .center
        altValueLabel?.textColor = .warmGrey
        altValueLabel?.text = coinPrefix

        blockchainFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        blockchainFee?.textAlignment = .left
        blockchainFee?.textColor = UIColor.warmGrey.withAlphaComponent(0.7)
        blockchainFee?.customAppearance.setIndent("blockchain fee   ")
        blockchainFee?.customAppearance.setText("$ 0.0")

        zamzamFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        zamzamFee?.textAlignment = .left
        zamzamFee?.textColor = UIColor.warmGrey.withAlphaComponent(0.7)
        zamzamFee?.customAppearance.setIndent("zamzam fee   ")
        zamzamFee?.customAppearance.setText("$ 0.0")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let view = feeContainer {
            let y = CGFloat(1.0)
            let x = view.bounds.width / 2
            let point = CGPoint(x: x, y: y)

            drawSeparator(in: view, center: point, width: view.bounds.width)
        }
    }

    func prepare(coinType: CoinType) {
        self.coin = coinType

        altValueLabel?.text = coinPrefix
    }

    // MARK: - AmountTextField

    @objc
    private func valueTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, let coin = coin else {
            return
        }

        //let stringValue = text[coinPrefix.count..<text.count]

        let value = NumberFormatter.walletAmount.number(from: text)?.decimalValue ?? 0.0
        let stringValue = NumberFormatter.walletAmount.string(from: value as NSNumber) ?? text
        let detailValue: Float = 0.0

        if value != amount {
            if value > 0 {
                let balanceData = BalanceData(coin: coin, usd: 0.0, original: value)
                delegate?.sendMoneyAmountComponent(self, amountDataEntered: balanceData)
            } else {
                delegate?.sendMoneyAmountComponentValueEnteredIncorrectly(self)
            }

            self.amount = value
            self.detail = detailValue
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let decimalSeparator = NumberFormatter.walletAmount.decimalSeparator!
        let nondecimalCharacters = NSCharacterSet(charactersIn: "0123456789" + decimalSeparator).inverted

        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        let replacementTextHasNonDecimals = string.rangeOfCharacter(from: nondecimalCharacters)

        // Restricting write nondecimal characters
        if let _ = replacementTextHasNonDecimals {
            return false
        }

        // Restricting write second decimal separator
        if let _ = existingTextHasDecimalSeparator, let _ = replacementTextHasDecimalSeparator {
            return false
        }

        return true
    }
}
