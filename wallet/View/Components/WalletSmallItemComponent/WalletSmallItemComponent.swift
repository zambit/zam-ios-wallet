//
//  WalletSmallItem.swift
//  wallet
//
//  Created by Alexander Ponomarev on 16/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletSmallItemComponent: ItemComponent, Configurable {

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet var coinNameLabel: UILabel!
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

        self.coinNameLabel.gradientLayer.frame = self.coinNameLabel.bounds
        self.phoneNumberLabel.gradientLayer.frame = self.phoneNumberLabel.bounds
        self.balanceLabel.gradientLayer.frame = self.balanceLabel.bounds
        self.fiatBalanceLabel.gradientLayer.frame = self.fiatBalanceLabel.bounds

        self.view.layer.cornerRadius = 12.0
        self.view.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath

        self.iconImageView.layer.cornerRadius = iconImageView.bounds.width / 2
    }

    override func setupStyle() {
        super.setupStyle()

        pageControl?.currentPageIndicatorTintColor = .blueGrey
        pageControl?.pageIndicatorTintColor = UIColor.blueGrey.withAlphaComponent(0.4)
        pageControl?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        iconImageView.maskToBounds = true

        balanceLabel.textColor = .darkIndigo
        balanceLabel.font = UIFont.walletFont(ofSize: 18.0, weight: .bold)
        balanceLabel.lineBreakMode = .byCharWrapping
        balanceLabel.text = "00.000"

        fiatBalanceLabel.textColor = .blueGrey
        fiatBalanceLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        fiatBalanceLabel.lineBreakMode = .byCharWrapping
        fiatBalanceLabel.text = "$ 0.000"

        phoneNumberLabel.textColor = .blueGrey
        phoneNumberLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
        phoneNumberLabel.text = "+7 999 999-99-99"

        let mainColor = UIColor.darkIndigo
        let font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        coinNameLabelMainAttributes = [.foregroundColor: mainColor, .font: font]

        let additColor = UIColor.blueGrey
        coinNameLabelAdditAttributes = [.foregroundColor: additColor, .font: font]

        coinNameLabel.text = "Bitcoin wallet BTC"

        self.view.backgroundColor = .white

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.view.layer.shadowOffset = CGSize(width: -2.0, height: 4.0)
        self.view.layer.shadowRadius = 21.0
        self.view.layer.shadowOpacity = 0.5
    }

    override func stiffen() {
        iconImageView?.stiffen()
        coinNameLabel?.stiffen()
        phoneNumberLabel?.stiffen()
        balanceLabel?.stiffen()
        fiatBalanceLabel?.stiffen()
    }

    override func relive() {
        iconImageView?.relive()
        coinNameLabel?.relive()
        phoneNumberLabel?.relive()
        balanceLabel?.relive()
        fiatBalanceLabel?.relive()
    }

    func configure(with data: WalletItemData) {
        let coinNameText = NSAttributedString(string: data.name, attributes: coinNameLabelMainAttributes)
        let coinAdditText = NSAttributedString(string: " \(data.short)", attributes: coinNameLabelAdditAttributes)

        let mutableCoinText = NSMutableAttributedString(attributedString: coinNameText)
        mutableCoinText.append(coinAdditText)

        coinNameLabel.attributedText = mutableCoinText

        iconImageView.image = data.icon
        phoneNumberLabel.text = data.phoneNumber
        balanceLabel.text = String(describing: data.balance)
        fiatBalanceLabel.text = String(describing: data.fiatBalance)
    }

    func setupPages(currentIndex: Int, count: Int) {
        pageControl?.numberOfPages = count
        pageControl?.currentPage = currentIndex
    }

    func setupChart(points: [ChartLayer.Coordinate]) {
        let layer = ChartLayer(size: view.size, points: points)
        layer.insets = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 20.0, right: 0.0)
        layer.chartBorderColor = UIColor.lightblue.withAlphaComponent(0.25).cgColor
        layer.chartFillingGradientColors = [UIColor.paleGrey.cgColor, UIColor.white.cgColor]

        layer.zPosition = -1
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        layer.name = "chart"

        view.layer.sublayers?.forEach({
            if $0.name == "chart" {
                $0.removeFromSuperlayer()
            }
        })

        view.layer.addSublayer(layer)
    }

    func setTargetToAnimation() {
        self.view.hero.id = "walletView"
        self.view.hero.modifiers = [.arc(intensity: 1)]
        self.iconImageView.hero.id = "walletIconImageView"
        self.coinNameLabel.hero.id = "walletCoinNameLabel"
        self.phoneNumberLabel.hero.id = "walletPhoneNumberLabel"
        self.balanceLabel.hero.id = "walletBalanceLabel"
        self.fiatBalanceLabel.hero.id = "walletFiatBalanceLabel"
    }

    func removeTargetToAnimation() {
        self.view.hero.id = nil
        self.iconImageView.hero.id = nil
        self.coinNameLabel.hero.id = nil
        self.phoneNumberLabel.hero.id = nil
        self.balanceLabel.hero.id = nil
        self.fiatBalanceLabel.hero.id = nil
    }
}
