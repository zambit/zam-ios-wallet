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

class SendMoneyAmountComponent: Component, SizePresetable, UITextFieldDelegate {

    weak var delegate: SendMoneyAmountComponentDelegate?
    
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var valueTextField: UITextField?
    @IBOutlet private var altValueLabel: UILabel?

    @IBOutlet private var feeContainer: UIView?

    @IBOutlet private var blockchainFee: IndentLabel?
    @IBOutlet private var zamzamFee: IndentLabel?

    @IBOutlet private var feesHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var feesBottomGreaterThanConstraint: NSLayoutConstraint?
    @IBOutlet private var feesTopConstraint: NSLayoutConstraint?
    @IBOutlet private var valueTextFieldHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var titleLabelHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var topInitialConstraint: NSLayoutConstraint?
    @IBOutlet private var valueTextFieldTopConstraint: NSLayoutConstraint?
    @IBOutlet private var valueTextFieldBottomConstraint: NSLayoutConstraint?
    @IBOutlet private var topGreaterThanConstraint: NSLayoutConstraint?

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
            NSAttributedString(string: NumberFormatter.walletAmount.string(from: 0.0)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkIndigo])

        altValueLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        altValueLabel?.textAlignment = .center
        altValueLabel?.textColor = .warmGrey
        altValueLabel?.text = coinPrefix

        blockchainFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        blockchainFee?.textAlignment = .left
        blockchainFee?.textColor = UIColor.warmGrey.withAlphaComponent(0.7)
        blockchainFee?.custom.setIndent("blockchain fee   ")
        blockchainFee?.custom.setText("$ \(NumberFormatter.walletAmount.string(from: 0.0)!)")

        zamzamFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        zamzamFee?.textAlignment = .left
        zamzamFee?.textColor = UIColor.warmGrey.withAlphaComponent(0.7)
        zamzamFee?.custom.setIndent("zamzam fee   ")
        zamzamFee?.custom.setText("$ \(NumberFormatter.walletAmount.string(from: 0.0)!)")
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

    func prepare(preset: SizePreset) {
        switch preset {
        case .superCompact:
            blockchainFee?.custom.setIndent("blockch. fee   ")
            blockchainFee?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
            zamzamFee?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
            valueTextField?.font = UIFont.walletFont(ofSize: 36.0, weight: .regular)
            titleLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)

            feesTopConstraint?.constant = 10.0
            feesHeightConstraint?.constant = 30.0
            feesBottomGreaterThanConstraint?.constant = 0.0
            valueTextFieldHeightConstraint?.constant = 36.0
            topInitialConstraint?.constant = 10.0
            topGreaterThanConstraint?.constant = 10
            valueTextFieldTopConstraint?.constant = 5.0
            valueTextFieldBottomConstraint?.constant = 5.0
            titleLabelHeightConstraint?.constant = 16.0
        case .compact, .default, .large:
            blockchainFee?.custom.setIndent("blockchain fee   ")
            blockchainFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
            zamzamFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
            valueTextField?.font = UIFont.walletFont(ofSize: 46.0, weight: .regular)
            titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)

            feesTopConstraint?.constant = 20.0
            feesHeightConstraint?.constant = 51.0

            switch preset {
            case .compact:
                topGreaterThanConstraint?.constant = 15
                feesBottomGreaterThanConstraint?.constant = 0
            case .default:
                topGreaterThanConstraint?.constant = 35
                feesBottomGreaterThanConstraint?.constant = 20
            default:
                break
            }

            valueTextFieldHeightConstraint?.constant = 54.0
            topInitialConstraint?.constant = 35.0
            valueTextFieldTopConstraint?.constant = 10.0
            valueTextFieldBottomConstraint?.constant = 10.0
            titleLabelHeightConstraint?.constant = 19.5
        }

        layoutIfNeeded()
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

        let value = NumberFormatter.walletAmount.number(from: text)?.decimalValue ?? 0.0
        //let value = Decimal(string: text) ?? 0.0
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

        if textField.text == "", string == "0" {
            textField.text?.append("0\(NumberFormatter.walletAmount.decimalSeparator!)")
            return false
        }

        if textField.text == "0\(NumberFormatter.walletAmount.decimalSeparator!)", string == "" {
            textField.text = ""
            return false
        }

        return true
    }
}
