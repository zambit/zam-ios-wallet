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

class WalletItemComponent: WalletSmallItemComponent {

    var onSendButtonTap: (() -> Void)?

    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var depositButton: UIButton!

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
        sendButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4.0)
        sendButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8.0, 0, -8)
        sendButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        sendButton.addTarget(self, action: #selector(sendButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        depositButton.setTitle("Deposit", for: .normal)
        depositButton.setImage(#imageLiteral(resourceName: "icArrowUpGreen"), for: .normal)
        depositButton.setTitleColor(.blueGrey, for: .normal)
        depositButton.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        depositButton.tintColor = UIColor.blueGrey.withAlphaComponent(0.4)
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

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: UIButton) {
        onSendButtonTap?()
    }

    @objc
    private func longPressGestureEvent(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.5) {
                [weak self] in
                self?.view.transform = .init(scaleX: 0.95, y: 0.95)
            }
        case .ended:
            UIView.animate(withDuration: 0.5) {
                [weak self] in
                self?.view.transform = .identity
            }
        default:
            return
        }
    }
}
