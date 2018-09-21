//
//  MenuButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 14/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class MenuButton: UIButton {

    var describingLabel: UILabel?
    var indicatorImageView: UIImageView?

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                custom.highlightButton()
            } else {
                custom.unhighlightButton()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        custom.setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(nil, for: UIControl.State())
        custom.setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle(nil, for: UIControl.State())
        custom.setupStyle()
    }
}

extension BehaviorExtension where Base: MenuButton {

    func setup(title: String, image: UIImage) {
        setupSubviews()

        base.describingLabel?.text = title
        base.indicatorImageView?.image = image
    }

    func setupStyle() {
        base.backgroundColor = .white

        base.layer.masksToBounds = false
        base.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        base.layer.shadowOffset = CGSize(width: -2.0, height: 4.0)
        base.layer.shadowRadius = 21.0
        base.layer.shadowOpacity = 0.5
    }

    func setupLayouts() {
        base.layer.cornerRadius = 12
    }

    func setupSubviews() {
        base.viewWithTag(4519319)?.removeFromSuperview()
        base.viewWithTag(9144919)?.removeFromSuperview()

        let describingLabel = UILabel()
        describingLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        describingLabel.textAlignment = .left
        describingLabel.numberOfLines = 1
        describingLabel.tag = 4519319

        base.addSubview(describingLabel)

        describingLabel.translatesAutoresizingMaskIntoConstraints = false
        describingLabel.topAnchor.constraint(greaterThanOrEqualTo: base.topAnchor, constant: 4.0).isActive = true
        describingLabel.bottomAnchor.constraint(lessThanOrEqualTo: base.bottomAnchor, constant: -4.0).isActive = true
        describingLabel.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 23.0).isActive = true
        describingLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true

        base.describingLabel = describingLabel

        let indicatorImageView = UIImageView()
        indicatorImageView.tag = 9144919
        indicatorImageView.tintColor = .skyBlue
        indicatorImageView.contentMode = .scaleAspectFill

        base.addSubview(indicatorImageView)

        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorImageView.leftAnchor.constraint(greaterThanOrEqualTo: describingLabel.rightAnchor, constant: 8.0).isActive = true
        indicatorImageView.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -21.0).isActive = true
        indicatorImageView.topAnchor.constraint(equalTo: base.topAnchor, constant: 16.0).isActive = true
        indicatorImageView.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -16.0).isActive = true
        indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor).isActive = true

        base.indicatorImageView = indicatorImageView
    }

    func unhighlightButton() {
        base.indicatorImageView?.tintColor = .skyBlue
        base.describingLabel?.textColor = UIColor.darkIndigo
    }

    func highlightButton() {
        base.indicatorImageView?.tintColor = UIColor.skyBlue.withAlphaComponent(0.3)
        base.describingLabel?.textColor = UIColor.darkIndigo.withAlphaComponent(0.3)
    }

    func setEnabled(_ enabled: Bool) {
        base.isUserInteractionEnabled = enabled
        base.alpha = enabled ? 1.0 : 0.3

        base.layer.shadowRadius = enabled ? 21.0 : 12.0
        //base.layer.shadowOpacity = enabled ? 0.5 : 0.2
    }
}
