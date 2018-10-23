//
//  WalletItemComponent.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletItemComponent: WalletSmallItemComponent {

    var onSendButtonTap: (() -> Void)?
    var onDepositButtonTap: (() -> Void)?
    var onCardLongPress: (() -> Void)?

    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var depositButton: UIButton!

    override func layoutSubviews() {
        super.layoutSubviews()

        self.sendButton.gradientLayer.frame = self.sendButton.bounds
        self.depositButton.gradientLayer.frame = self.depositButton.bounds
    }

    override func initFromNib() {
        super.initFromNib()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureEvent(_:)))
        longPressGesture.minimumPressDuration = 0.15

        view.addGestureRecognizer(longPressGesture)
    }

    override func setupStyle() {
        super.setupStyle()

        sendButton.setTitle("Send", for: .normal)
        sendButton.setImage(#imageLiteral(resourceName: "icArrowDownBlue"), for: .normal)
        sendButton.setTitleColor(.blueGrey, for: .normal)
        sendButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        sendButton.contentHorizontalAlignment = .left
        //sendButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        sendButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4.0)
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: -8)
        sendButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        sendButton.addTarget(self, action: #selector(sendButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        depositButton.setTitle("Deposit", for: .normal)
        depositButton.setImage(#imageLiteral(resourceName: "icArrowUpGreen"), for: .normal)
        depositButton.setTitleColor(.blueGrey, for: .normal)
        depositButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        depositButton.tintColor = UIColor.blueGrey.withAlphaComponent(0.4)
        depositButton.contentHorizontalAlignment = .left
        //depositButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        depositButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4.0)
        depositButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: -8.0)
        depositButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        depositButton.addTarget(self, action: #selector(depositButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.view.backgroundColor = .white

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.silverTwo.cgColor
        self.view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.view.layer.shadowRadius = 21.0
        self.view.layer.shadowOpacity = 0.5
    }

    override func stiffen() {
        super.stiffen()

        sendButton?.stiffen()
        depositButton?.stiffen()
    }

    override func relive() {
        super.relive()

        sendButton?.relive()
        depositButton?.relive()
    }

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: UIButton) {
        onSendButtonTap?()
    }

    @objc
    private func depositButtonTouchUpInsideEvent(_ sender: UIButton) {
        onDepositButtonTap?()
    }

    @objc
    private func longPressGestureEvent(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: {
                _ in
                self.onCardLongPress?()
            })
        case .ended:
            UIView.animate(withDuration: 0.5) {
                self.view.transform = .identity
            }
        default:
            return
        }
    }
}
