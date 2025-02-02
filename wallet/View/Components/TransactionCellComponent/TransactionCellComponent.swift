//
//  TransactionItemComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionCellComponent: CellComponent, Configurable {

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var recipientLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!

    private var titleLabelMainAttributes: [NSAttributedString.Key: Any] = [:]
    private var titleLabelAdditAttributes: [NSAttributedString.Key: Any] = [:]

    override func setupStyle() {
        super.setupStyle()

        amountLabel.textColor = .darkIndigo
        amountLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)

        fiatAmountLabel.textColor = .blueGrey
        fiatAmountLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)

        recipientLabel.textColor = .blueGrey
        recipientLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)

        let mainColor = UIColor.darkIndigo
        let font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        titleLabelMainAttributes = [.foregroundColor: mainColor, .font: font]

        let additColor = UIColor.blueGrey
        titleLabelAdditAttributes = [.foregroundColor: additColor, .font: font]

        self.view.backgroundColor = .white
    }

    func configure(with data: WalletDetailsTransactionViewData) {
        self.configure(image: data.image, status: data.status, coinShort: data.coinShort, recipient: data.recipient, amount: data.amount, fiatAmount: data.fiatAmount, direction: data.direction)
    }

    func configure(image: UIImage, status: String, coinShort: String, recipient: String, amount: String, fiatAmount: String, direction: DirectionType) {
        var amountColor: UIColor
        var amountPrefix: String

        switch direction {
        case .incoming:
            amountColor = .weirdGreen
            amountPrefix = "+"
        case .outgoing:
            amountColor = .darkIndigo
            amountPrefix = "-"
        }

        let statusText = NSAttributedString(string: status.capitalizingFirst, attributes: titleLabelMainAttributes)
        let coinShortText = NSAttributedString(string: " \(coinShort.uppercased())", attributes: titleLabelAdditAttributes)

        let mutableTitleText = NSMutableAttributedString(attributedString: statusText)
        mutableTitleText.append(coinShortText)

        titleLabel.attributedText = mutableTitleText

        iconImageView.image = image
        recipientLabel.text = recipient
        amountLabel?.textColor = amountColor
        amountLabel.text = "\(amountPrefix) \(amount)"
        fiatAmountLabel.text = String(describing: fiatAmount)
    }

    func update(recipient: String) {
        recipientLabel.text = recipient
    }

}
