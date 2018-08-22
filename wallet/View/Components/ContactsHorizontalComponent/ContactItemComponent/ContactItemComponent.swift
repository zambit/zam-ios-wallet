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

    @IBOutlet private var avatarImageView: RoundedImageView!
    @IBOutlet private var fullNameLabel: UILabel!

    override func initFromNib() {
        super.initFromNib()

        insets = UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

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
}
