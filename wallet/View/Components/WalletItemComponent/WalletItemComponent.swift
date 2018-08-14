//
//  WalletItemComponent.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import LayoutKit

class WalletItemComponent: ItemComponent {

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var phoneNumberLabel: UILabel!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var fiatBalanceLabel: UILabel!

    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var depositButton: UIButton!

    private var coinNameLabelMainAttributes: [NSAttributedStringKey: Any] = [:]
    private var coinNameLabelAdditAttributes: [NSAttributedStringKey: Any] = [:]
    
    override func initFromNib() {
        super.initFromNib()

        insets = UIEdgeInsetsMake(7.0, 16.0, 7.0, 16.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.view.layer.cornerRadius = 12.0
        self.view.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath

        self.iconImageView.layer.cornerRadius = iconImageView.bounds.width / 2
    }

    override func setupStyle() {
        super.setupStyle()

        balanceLabel.textColor = .darkIndigo
        balanceLabel.font = UIFont.walletFont(ofSize: 18.0, weight: .bold)
        balanceLabel.lineBreakMode = .byCharWrapping

        fiatBalanceLabel.textColor = .blueGrey
        fiatBalanceLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        fiatBalanceLabel.lineBreakMode = .byCharWrapping

        phoneNumberLabel.textColor = .blueGrey
        phoneNumberLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)

        let mainColor = UIColor.darkIndigo
        let font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        coinNameLabelMainAttributes = [.foregroundColor: mainColor, .font: font]

        let additColor = UIColor.blueGrey
        coinNameLabelAdditAttributes = [.foregroundColor: additColor, .font: font]

        sendButton.setTitle("Send", for: .normal)
        sendButton.setImage(#imageLiteral(resourceName: "icArrowDownBlue"), for: .normal)
        sendButton.setTitleColor(.blueGrey, for: .normal)
        sendButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        sendButton.contentHorizontalAlignment = .left
        sendButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4.0)
        sendButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8.0, 0, -8)
        sendButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

        depositButton.setTitle("Deposit", for: .normal)
        depositButton.setImage(#imageLiteral(resourceName: "icArrowUpGreen"), for: .normal)
        depositButton.setTitleColor(.blueGrey, for: .normal)
        depositButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        depositButton.contentHorizontalAlignment = .left
        depositButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4.0)
        depositButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8.0, 0, -8.0)
        depositButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

        self.view.backgroundColor = .white

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.silverTwo.cgColor
        self.view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.view.layer.shadowRadius = 21.0
        self.view.layer.shadowOpacity = 0.5
    }

    func configure(image: UIImage, coinName: String, coinAddit: String, phoneNumber: String, balance: String, fiatBalance: String) {
        let coinNameText = NSAttributedString(string: coinName, attributes: coinNameLabelMainAttributes)
        let coinAdditText = NSAttributedString(string: " \(coinAddit)", attributes: coinNameLabelAdditAttributes)

        let mutableCoinText = NSMutableAttributedString(attributedString: coinNameText)
        mutableCoinText.append(coinAdditText)

        coinNameLabel.attributedText = mutableCoinText

        iconImageView.image = image
        phoneNumberLabel.text = phoneNumber
        balanceLabel.text = String(describing: balance)
        fiatBalanceLabel.text = String(describing: fiatBalance)
    }
}
