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

    func sendMoneyAmountComponent(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amountValueEntered value: Float, stringFormat: String)

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

    private var coinType: CoinType? = .btc

    private var coinPrefix: String = ""

    private(set) var amount: Float = 0
    private(set) var detail: Float = 0

    override func initFromNib() {
        super.initFromNib()

        valueTextField?.delegate = self

        valueTextField?.addTarget(self, action: #selector(valueTextFieldEditingBegin(_:)), for: .editingDidBegin)
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

    private func componentDidPrepared() {
        altValueLabel?.text = coinPrefix
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
        self.coinType = coinType
        self.coinPrefix = "\(coinType.short.uppercased())"

        self.componentDidPrepared()
    }

    // MARK: - AmountTextField

    @objc
    private func valueTextFieldEditingBegin(_ sender: UITextField) {
        //sender.text?.addPrefixIfNeeded(coinPrefix)
    }

    @objc
    private func valueTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        //let stringValue = text[coinPrefix.count..<text.count]
        let stringValue = text
        let numberFormatter = NumberFormatter()

        let value = numberFormatter.number(from: stringValue)?.floatValue ?? 0.0
        let detailValue: Float = 0.0

        if value != amount {
            if value > 0 {
                delegate?.sendMoneyAmountComponent(self, amountValueEntered: value, stringFormat: "\(String(value)) \(coinPrefix)")
            } else {
                delegate?.sendMoneyAmountComponentValueEnteredIncorrectly(self)
            }

            self.amount = value
            self.detail = detailValue
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let locale = Locale.current
        let decimalSeparator = locale.decimalSeparator ?? "."
        let nondecimalCharacters = NSCharacterSet(charactersIn: "-0123456789" + decimalSeparator).inverted

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
