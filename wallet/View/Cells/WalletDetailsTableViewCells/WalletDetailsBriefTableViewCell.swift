//
//  WalletDetailsBriefTableViewCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol WalletDetailsBriefDelegate: class {

    func walletDetailsBriefSendButtonTapped(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, walletIndex: Int)

    func walletDetailsBriefDepositButtonTapped(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, walletIndex: Int)

    func walletDetailsBriefCurrentWalletChanged(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, to index: Int)
}

class WalletDetailsBriefTableViewCell: UITableViewCell, WalletsCollectionComponentDelegate {

    weak var delegate: WalletDetailsBriefDelegate?

    private var coinPriceLabel: UILabel?
    private var coinChangeLabel: UILabel?

    private var walletsCollection: WalletsCollectionComponent?

    private var sendButton: UIButton?
    private var depositButton: UIButton?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
        setupSubviews()
    }

    private func setupStyle() {
        self.backgroundColor = .white
    }

    private func setupSubviews() {
        self.hero.isEnabled = true

        let coinPriceLabel = UILabel()
        coinPriceLabel.hero.modifiers = [.fade]
        coinPriceLabel.font = UIFont.walletFont(ofSize: 18.0, weight: .medium)
        coinPriceLabel.textColor = .darkIndigo
        coinPriceLabel.textAlignment = .left

        self.addSubview(coinPriceLabel)
        coinPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        coinPriceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30.0).isActive = true
        coinPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18.0).isActive = true

        self.coinPriceLabel = coinPriceLabel


        let coinChangeLabel = UILabel()
        coinChangeLabel.hero.modifiers = [.fade]
        coinChangeLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        coinChangeLabel.textColor = .darkIndigo
        coinChangeLabel.textAlignment = .right

        self.addSubview(coinChangeLabel)
        coinChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        coinChangeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -26.0).isActive = true
        coinChangeLabel.bottomAnchor.constraint(equalTo: coinPriceLabel.bottomAnchor).isActive = true

        self.coinChangeLabel = coinChangeLabel


        let walletsCollection = WalletsCollectionComponent()
        walletsCollection.delegate = self

        self.addSubview(walletsCollection)
        walletsCollection.translatesAutoresizingMaskIntoConstraints = false
        walletsCollection.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        walletsCollection.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        walletsCollection.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        walletsCollection.topAnchor.constraint(equalTo: coinPriceLabel.bottomAnchor, constant: 10.0).isActive = true

        self.walletsCollection = walletsCollection


        let sendButton = UIButton(type: .custom)
        sendButton.hero.modifiers = [.fade]
        sendButton.setTitle("Send", for: .normal)
        sendButton.setImage(#imageLiteral(resourceName: "icArrowDownBlue"), for: .normal)
        sendButton.setTitleColor(.blueGrey, for: .normal)
        sendButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        sendButton.contentHorizontalAlignment = .left
        sendButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 4.0)
        sendButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8.0, bottom: 0, right: -8)
        sendButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        sendButton.addTarget(self, action: #selector(sendButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 62.0).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        //sendButton.topAnchor.constraint(greaterThanOrEqualTo: walletsCollection.bottomAnchor, constant: 0.0).isActive = true
        sendButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 70.0).isActive = true

        self.sendButton = sendButton


        let depositButton = UIButton(type: .custom)
        depositButton.hero.modifiers = [.fade]
        depositButton.setTitle("Deposit", for: .normal)
        depositButton.setImage(#imageLiteral(resourceName: "icArrowUpGreen"), for: .normal)
        depositButton.setTitleColor(.blueGrey, for: .normal)
        depositButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        depositButton.tintColor = UIColor.blueGrey.withAlphaComponent(0.4)
        depositButton.contentHorizontalAlignment = .left
        depositButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 4.0)
        depositButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8.0, bottom: 0, right: -8.0)
        depositButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        depositButton.addTarget(self, action: #selector(depositButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.addSubview(depositButton)
        depositButton.translatesAutoresizingMaskIntoConstraints = false
        depositButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        depositButton.widthAnchor.constraint(equalToConstant: 78.0).isActive = true
        depositButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        //depositButton.topAnchor.constraint(greaterThanOrEqualTo: walletsCollection.bottomAnchor, constant: 0.0).isActive = true
        depositButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60.0).isActive = true

        self.sendButton = sendButton
    }

    func configure(currentIndex: Int, wallets: [WalletItemData]) {
        self.coinPriceLabel?.text = " "
        self.walletsCollection?.custom.prepare(cards: wallets, current: currentIndex)
    }

    func update(price: String, change: String, changePct: String, isChangePositive: Bool) {
        let priceAppending = " (\(isChangePositive ? "+" : "")\(changePct))"

        let priceAttributedString = NSMutableAttributedString(string: price + priceAppending, attributes: [
            .font: UIFont.walletFont(ofSize: 18.0, weight: .medium),
            .foregroundColor: UIColor.darkIndigo,
            .kern: -0.5
            ])

        priceAttributedString.addAttributes([
            .font: UIFont.walletFont(ofSize: 16.0, weight: .regular),
            .foregroundColor: isChangePositive ? UIColor.lightishGreenTwo : UIColor.error
            ], range: NSRange(location: price.count, length: priceAppending.count))

        self.coinPriceLabel?.attributedText = priceAttributedString


        let changePrimary = "\(isChangePositive ? "+" : "")\(change)"
        let changeAppending = " (24h)"

        let changeAttributedString = NSMutableAttributedString(string: changePrimary + changeAppending, attributes: [
            .font: UIFont.walletFont(ofSize: 16.0, weight: .regular),
            .foregroundColor: isChangePositive ? UIColor.lightishGreenTwo : UIColor.error,
            .kern: -0.5
            ])

        changeAttributedString.addAttributes([
            .font: UIFont.walletFont(ofSize: 16.0, weight: .regular),
            .foregroundColor: UIColor.blueGrey
            ], range: NSRange(location: changePrimary.count, length: changeAppending.count))

        self.coinChangeLabel?.attributedText = changeAttributedString
    }

    func update(currentIndex: Int) {
        self.walletsCollection?.custom.updateCurrentWallet(currentIndex)
    }

    // MARK: - WalletsCollectionComponentDelegate

    func walletsCollectionComponentCurrentIndexChanged(_ walletsCollectionComponent: WalletsCollectionComponent, to index: Int) {
        walletsCollection?.custom.prepareForAnimation()
        delegate?.walletDetailsBriefCurrentWalletChanged(self, to: index)
    }

    // MARK: - Buttons events

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let currentIndex = walletsCollection?.currentIndex else {
            return
        }

        delegate?.walletDetailsBriefSendButtonTapped(self, walletIndex: currentIndex)
    }

    @objc
    private func depositButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let currentIndex = walletsCollection?.currentIndex else {
            return
        }

        delegate?.walletDetailsBriefDepositButtonTapped(self, walletIndex: currentIndex)
    }
}
