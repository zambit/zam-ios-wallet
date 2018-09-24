//
//  ContactItemComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class RectItemComponent: ItemComponent {

    var onTap: (() -> Void)?

    @IBOutlet private var avatarImageView: RoundedImageView!
    @IBOutlet private var nameLabel: UILabel!

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

        nameLabel.font = UIFont.walletFont(ofSize: 12, weight: .regular)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white

        self.view.backgroundColor = .darkSlateBlue

        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.view.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.view.layer.shadowRadius = 7.0
        self.view.layer.shadowOpacity = 0.2
    }

    func configure(avatar: UIImage, name: String) {
        self.avatarImageView.image = avatar
        self.nameLabel.text = name

        invalidateIntrinsicContentSize()
    }
}
