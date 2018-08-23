//
//  ContactItemComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class ContactItemComponent: ItemComponent {

    var onTap: (() -> Void)?

    @IBOutlet private var avatarImageView: RoundedImageView!
    @IBOutlet private var fullNameLabel: UILabel!

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 114.0 - insets.left - insets.right, height: 114.0 - insets.left - insets.right)
    }

    override func initFromNib() {
        super.initFromNib()

        insets = UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0)

        layoutIfNeeded()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureEvent(_:)))
        longPressGesture.minimumPressDuration = 0.1

        view.addGestureRecognizer(longPressGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.view.frame = CGRect(x: insets.left,
                            y: insets.top,
                            width: bounds.width - insets.left - insets.right,
                            height: bounds.height - insets.top - insets.bottom)

        self.view.layer.cornerRadius = 16.0
        self.view.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0).cgPath
    }

    override func setupStyle() {
        super.setupStyle()

        avatarImageView.clipsToBounds = true
        //avatarImageView.layer.borderWidth = 3.0
        //avatarImageView.layer.borderColor = UIColor.weirdGreen.cgColor

        fullNameLabel.font = UIFont.walletFont(ofSize: 12, weight: .regular)
        fullNameLabel.numberOfLines = 0
        fullNameLabel.textAlignment = .center
        fullNameLabel.textColor = .white

        self.view.backgroundColor = .darkSlateBlue

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.view.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.view.layer.shadowRadius = 7.0
        self.view.layer.shadowOpacity = 0.2
    }

    func configure(avatar: UIImage, name: String) {
        self.avatarImageView.image = avatar
        self.fullNameLabel.text = name
    }

    @objc
    private func longPressGestureEvent(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.25, animations: {
                [weak self] in
                self?.view.transform = .init(scaleX: 0.9, y: 0.9)
            }, completion: {
                [weak self] _ in

                self?.onTap?()
            })
        case .ended:
            UIView.animate(withDuration: 0.25) {
                [weak self] in
                self?.view.transform = .identity
            }
        default:
            return
        }
    }
}
