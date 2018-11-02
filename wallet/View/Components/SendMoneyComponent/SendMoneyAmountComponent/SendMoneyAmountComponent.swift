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

    func sendMoneyAmountComponentEditingChanged(_ sendMoneyAmountComponent: SendMoneyAmountComponent, amount: Amount)

    func sendMoneyAmountComponentValueEnteredIncorrectly(_ sendMoneyAmountComponent: SendMoneyAmountComponent)
}

class SendMoneyAmountComponent: Component, SizePresetable, UITextFieldDelegate {

    weak var delegate: SendMoneyAmountComponentDelegate?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var valueTextField: UITextField?
    @IBOutlet private var altValueLabel: UILabel?

    @IBOutlet private var exchangeButton: HighlightableButton?
    @IBOutlet private var maxButton: HighlightableButton?

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
    private var fiat: FiatType?
    private var coinPrice: CoinPrice?
    private var maxCoinValue: Decimal?
    private var maxFiatValue: Decimal?

    private var converter: Converter?
    private var isAmountInFiat: Bool = false

    private var coinPrefix: String {
        if let coin = coin {
            return "\(coin.short.uppercased())"
        }

        return ""
    }

    private(set) var amount: Decimal = 0.0

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
        valueTextField?.adjustsFontSizeToFitWidth = false
        valueTextField?.attributedPlaceholder =
            NSAttributedString(string: Decimal(0.0).longFormatted!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkIndigo])

        altValueLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        altValueLabel?.textAlignment = .center
        altValueLabel?.textColor = .warmGrey
        altValueLabel?.text = Decimal(0.0).longFormatted!

        exchangeButton?.setImage(#imageLiteral(resourceName: "icExchange"), for: .normal)
        exchangeButton?.tintColor = .silver
        exchangeButton?.setHighlightedTintColor(.warmGrey)
        exchangeButton?.addTarget(self, action: #selector(exchangeButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        maxButton?.titleLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
        maxButton?.setTitle("Max", for: .normal)
        maxButton?.setTitleColor(.silver, for: .normal)
        maxButton?.setTitleColor(.warmGrey, for: .highlighted)
        maxButton?.addTarget(self, action: #selector(maxButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        blockchainFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        blockchainFee?.textAlignment = .left
        blockchainFee?.textColor = UIColor.warmGrey.withAlphaComponent(0.7)
        blockchainFee?.custom.setIndent("blockchain fee   ")

        blockchainFee?.custom.setText("$ \(Decimal(0.0).longFormatted!)")

        zamzamFee?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        zamzamFee?.textAlignment = .left
        zamzamFee?.textColor = UIColor.warmGrey.withAlphaComponent(0.7)
        zamzamFee?.custom.setIndent("zamzam fee   ")
        zamzamFee?.custom.setText("$ \(Decimal(0.0).longFormatted!)")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let view = feeContainer {
            let y = CGFloat(1.0)
            let x = view.bounds.width / 2
            let point = CGPoint(x: x, y: y)

            DrawingHelper.drawSeparator(in: view, center: point, width: view.bounds.width)
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
            valueTextField?.font = UIFont.walletFont(ofSize: 42.0, weight: .regular)
            titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)

            feesTopConstraint?.constant = 20.0
            feesHeightConstraint?.constant = 51.0

            switch preset {
            case .compact:
                topGreaterThanConstraint?.constant = 15
                feesBottomGreaterThanConstraint?.constant = 0
                topInitialConstraint?.constant = 35.0
            case .default:
                topGreaterThanConstraint?.constant = 35
                feesBottomGreaterThanConstraint?.constant = 20
                topInitialConstraint?.constant = 35.0
            case .large:
                topGreaterThanConstraint?.constant = 25
                feesBottomGreaterThanConstraint?.constant = 0
                topInitialConstraint?.constant = 25
            default:
                break
            }

            valueTextFieldHeightConstraint?.constant = 54.0
            valueTextFieldTopConstraint?.constant = 10.0
            valueTextFieldBottomConstraint?.constant = 10.0
            titleLabelHeightConstraint?.constant = 19.5
        }

        layoutIfNeeded()
    }

    func prepare(coin: CoinType, fiat: FiatType, maxCoinValue: Decimal, maxFiatValue: Decimal, coinPrice: CoinPrice? = nil) {
        self.coin = coin
        self.fiat = fiat
        self.coinPrice = coinPrice
        self.maxCoinValue = maxCoinValue
        self.maxFiatValue = maxFiatValue

        self.converter = Converter(coin: coin, fiat: fiat, coinPrice: coinPrice)

        guard let converter = converter else {
            return
        }

        valueTextField?.text = ""
        delegate?.sendMoneyAmountComponentValueEnteredIncorrectly(self)

        if isAmountInFiat {
            altValueLabel?.text = "\(converter.coinValue.longFormatted?.removingWhitespaces ?? "") \(converter.coin.short.uppercased())"
        } else {
            altValueLabel?.text = "\(converter.fiat.symbol) \(converter.fiatValue.shortFormatted?.removingWhitespaces ?? "")"
        }
    }

    func prepare(coinPrice: CoinPrice? = nil) {
        self.coinPrice = coinPrice

        self.converter?.coinPrice = coinPrice

        guard let converter = converter else {
            return
        }

        if isAmountInFiat {
            altValueLabel?.text = "\(converter.coinValue.longFormatted?.removingWhitespaces ?? "") \(converter.coin.short.uppercased())"
        } else {
            altValueLabel?.text = "\(converter.fiat.symbol) \(converter.fiatValue.shortFormatted?.removingWhitespaces ?? "")"
        }
    }

    // MARK: - AmountTextField

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let coin = coin, let fiat = fiat else {
            return
        }

        if isAmountInFiat {
            titleLabel?.text = "\(fiat.symbol) \(maxFiatValue?.shortFormatted?.removingWhitespaces ?? "")"
        } else {
            titleLabel?.text = "\(maxCoinValue?.formatted?.removingWhitespaces ?? "") \(coin.short.uppercased())"
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        titleLabel?.text = "Amount"
    }

    @objc
    private func valueTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, let converter = self.converter else {
            return
        }

        let value = NumberFormatter.amount.number(from: text)?.decimalValue ?? 0.0

        if isAmountInFiat {
            if value != converter.fiatValue {
                self.converter?.fiatValue = value

                guard let converter = self.converter else {
                    return
                }

                self.altValueLabel?.text = "\(converter.coinValue.longFormatted?.removingWhitespaces ?? "") \(converter.coin.short.uppercased())"

                if converter.coinValue > 0 {
                    delegate?.sendMoneyAmountComponentEditingChanged(self, amount: converter.amount)
                } else {
                    delegate?.sendMoneyAmountComponentValueEnteredIncorrectly(self)
                }
            }
        } else {
            if value != converter.coinValue {
                self.converter?.coinValue = value

                guard let converter = self.converter else {
                    return
                }

                self.altValueLabel?.text = "\(converter.fiat.symbol) \(converter.fiatValue.shortFormatted?.removingWhitespaces ?? "")"

                if converter.coinValue > 0 {
                    delegate?.sendMoneyAmountComponentEditingChanged(self, amount: converter.amount)
                } else {
                    delegate?.sendMoneyAmountComponentValueEnteredIncorrectly(self)
                }
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let printingSeparator = "."
        let decimalSeparator = NumberFormatter.amount.decimalSeparator ?? ""
        let nondecimalCharacters = NSCharacterSet(charactersIn: "0123456789" + decimalSeparator + printingSeparator).inverted

        // Restricting write nondecimal characters

        let replacementTextHasNonDecimals = string.rangeOfCharacter(from: nondecimalCharacters)

        if let _ = replacementTextHasNonDecimals {
            return false
        }

        // Convert point to decimal separator

        var replacementString = string
        let separatorRanges = replacementString.ranges(of: printingSeparator)
        separatorRanges.forEach {
            replacementString.replaceSubrange($0, with: decimalSeparator)
        }

        // Restricting write second decimal separator

        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = replacementString.range(of: decimalSeparator)

        if let _ = existingTextHasDecimalSeparator, let _ = replacementTextHasDecimalSeparator {
            return false
        }

        if textField.text == "", string == printingSeparator {
            textField.text?.append("0\(decimalSeparator)")
            return false
        }

        if textField.text == "", string == "0" {
            textField.text?.append("0\(decimalSeparator)")
            return false
        }

        if textField.text == "0\(decimalSeparator)", string == "" {
            textField.text = ""
            return false
        }

        // replace current content with stripped content
        if let textRange = range.toTextRange(textInput: textField) {
            textField.replace(textRange, withText: replacementString)
            return false
        }

        return true
    }

    // MARK: - ExchangeButton

    @objc
    private func exchangeButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let converter = converter else {
            return
        }

        isAmountInFiat.toggle()

        if isAmountInFiat {
            valueTextField?.text = converter.fiatValue.shortFormatted?.removingWhitespaces ?? ""
            altValueLabel?.text = "\(converter.coinValue.longFormatted?.removingWhitespaces ?? "") \(converter.coin.short.uppercased())"
        } else {
            valueTextField?.text = converter.coinValue.longFormatted?.removingWhitespaces ?? ""
            altValueLabel?.text = "\(converter.fiat.symbol) \(converter.fiatValue.shortFormatted?.removingWhitespaces ?? "")"
        }
    }

    // MARK: - MarkButton

    @objc
    private func maxButtonTouchUpInsideEvent(_ sender: UIButton) {
        if isAmountInFiat {

            guard let maxValue = maxFiatValue else {
                return
            }

            self.converter?.fiatValue = maxValue

            valueTextField?.text = maxValue.shortFormatted?.removingWhitespaces ?? ""

            if let converter = converter {
                altValueLabel?.text = "\(converter.coinValue.longFormatted?.removingWhitespaces ?? "") \(converter.coin.short.uppercased())"
            }
        } else {
            guard let maxValue = maxCoinValue else {
                return
            }

            self.converter?.coinValue = maxValue

            valueTextField?.text = maxValue.longFormatted?.removingWhitespaces ?? ""

            if let converter = converter {
                altValueLabel?.text = "\(converter.fiat.symbol) \(converter.fiatValue.shortFormatted?.removingWhitespaces ?? "")"
            }
        }
    }
}
