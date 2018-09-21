//
//  WalletSmallItem.swift
//  wallet
//
//  Created by Alexander Ponomarev on 16/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletSmallItemComponent: ItemComponent {
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var phoneNumberLabel: UILabel!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var fiatBalanceLabel: UILabel!

    @IBOutlet private var pageControl: UIPageControl?

    private var coinNameLabelMainAttributes: [NSAttributedString.Key: Any] = [:]
    private var coinNameLabelAdditAttributes: [NSAttributedString.Key: Any] = [:]

    override func initFromNib() {
        super.initFromNib()

        insets = UIEdgeInsets.init(top: 7.0, left: 16.0, bottom: 7.0, right: 16.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.view.layer.cornerRadius = 12.0
        self.view.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath

        self.iconImageView.layer.cornerRadius = iconImageView.bounds.width / 2
    }

    override func setupStyle() {
        super.setupStyle()

        pageControl?.currentPageIndicatorTintColor = .blueGrey
        pageControl?.pageIndicatorTintColor = UIColor.blueGrey.withAlphaComponent(0.4)
        pageControl?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

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

        self.view.backgroundColor = .white

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.view.layer.shadowOffset = CGSize(width: -2.0, height: 4.0)
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

    func setupPages(currentIndex: Int, count: Int) {
        pageControl?.currentPage = currentIndex
        pageControl?.numberOfPages = count
    }
}
