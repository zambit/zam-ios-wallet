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
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var actualPriceLabel: UILabel!

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

        priceLabel.textColor = .darkIndigo
        actualPriceLabel.textColor = .blueGrey

        phoneNumberLabel.textColor = .blueGrey
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)

        let mainColor = UIColor.darkIndigo
        let font = UIFont.systemFont(ofSize: 16.0, weight: .medium)

        coinNameLabelMainAttributes = [.foregroundColor: mainColor, .font: font]

        let additColor = UIColor.blueGrey
        coinNameLabelAdditAttributes = [.foregroundColor: additColor, .font: font]

        self.view.backgroundColor = .white

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.silverTwo.cgColor
        self.view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.view.layer.shadowRadius = 21.0
        self.view.layer.shadowOpacity = 0.5
    }

    func configure(image: UIImage, coinName: String, coinAddit: String, phoneNumber: String, price: String) {
        let coinNameText = NSAttributedString(string: coinName, attributes: coinNameLabelMainAttributes)
        let coinAdditText = NSAttributedString(string: " \(coinAddit)", attributes: coinNameLabelAdditAttributes)

        let mutableCoinText = NSMutableAttributedString(attributedString: coinNameText)
        mutableCoinText.append(coinAdditText)

        coinNameLabel.attributedText = mutableCoinText

        iconImageView.image = image
        phoneNumberLabel.text = phoneNumber
        priceLabel.text = price
    }
}
