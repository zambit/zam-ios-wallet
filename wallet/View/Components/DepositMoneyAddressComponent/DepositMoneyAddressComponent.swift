//
//  DepositMoneyAddressComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DepositMoneyAddressComponent: Component {

    var onShare: ((String) -> Void)?

    @IBOutlet private var qrImageView: UIImageView?
    @IBOutlet private var addressLabel: UILabel?
    @IBOutlet private var copyAddressButton: OutputButton?
    @IBOutlet private var shareAddressButton: OutputButton?

    @IBOutlet private var imageHeightConstraint: NSLayoutConstraint?

    private var address: String?

    override func initFromNib() {
        super.initFromNib()

        switch UIScreen.main.type {
        case .extraSmall, .small:
            imageHeightConstraint?.constant = 100.0
        case .medium:
            imageHeightConstraint?.constant = 200.0
        case .plus:
            imageHeightConstraint?.constant = 250.0
        case .extra, .extraLarge:
            imageHeightConstraint?.constant = 270.0
        case .unknown:
            fatalError()
        }
    }

    override func setupStyle() {
        super.setupStyle()

        self.backgroundColor = .white

        addressLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        addressLabel?.textAlignment = .center
        addressLabel?.textColor = .black

        copyAddressButton?.setImage(#imageLiteral(resourceName: "copy"), for: .normal)
        copyAddressButton?.setTitle("Copy address", for: .normal)
        copyAddressButton?.tintColor = .skyBlue
        copyAddressButton?.setTitleColor(.black, for: .normal)
        copyAddressButton?.titleLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        copyAddressButton?.addTarget(self, action: #selector(copyAddressButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        shareAddressButton?.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        shareAddressButton?.setTitle("Share address", for: .normal)
        shareAddressButton?.tintColor = .skyBlue
        shareAddressButton?.imageView?.contentMode = .scaleAspectFit
        shareAddressButton?.setTitleColor(.black, for: .normal)
        shareAddressButton?.titleLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        shareAddressButton?.addTarget(self, action: #selector(shareAddressButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func prepare(address: String) {
        self.address = address

        updateContentWith(address: address)
    }

    private func updateContentWith(address: String) {
        guard let label = addressLabel, let imageView = qrImageView else {
            return
        }

        label.text = address
        imageView.image = UIImage.qrCode(from: address, size: imageView.bounds.size)
    }

    @objc
    private func copyAddressButtonTouchUpInsideEvent(_ sender: OutputButton) {
        UIPasteboard.general.string = address ?? ""
    }

    @objc
    private func shareAddressButtonTouchUpInsideEvent(_ sender: OutputButton) {
        guard let address = address else {
            return
        }

        onShare?(address)
    }
}
