//
//  FeatureCellComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class FeatureItemComponent: ItemComponent {

    var onTap: (() -> Void)?

    @IBOutlet private var featureButton: MultiStatableButton?

    override var intrinsicContentSize: CGSize {
        if let button = featureButton {
            return button.intrinsicContentSize
        }

        return CGSize(width: 100.0, height: 30.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let button = featureButton {
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }

    override func initFromNib() {
        super.initFromNib()

        if #available(iOS 12.0, *) {
            contentView.translatesAutoresizingMaskIntoConstraints = false

            // Code below is needed to make the self-sizing cell work when building for iOS 12 from Xcode 10.0:
            let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
            let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
            let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
            let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        }

        featureButton?.contentEdgeInsets = UIEdgeInsets.init(top: 8.0, left: 25.0, bottom: 8.0, right: 25.0)
        featureButton?.layer.borderWidth = 1.5
        featureButton?.layer.borderColor = UIColor.skyBlue.cgColor
        featureButton?.addTarget(self, action: #selector(featureButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func configure(title: String) {
        featureButton?.custom.setup(states: [title, title], colors: [UIColor.white, UIColor.white], backgroundColors: [.clear, .skyBlue])
        featureButton?.sizeToFit()
        invalidateIntrinsicContentSize()
    }

    func select() {
        featureButton?.custom.currentStateIndex = 1
    }

    func unselect() {
        featureButton?.custom.currentStateIndex = 0
    }

    @objc
    private func featureButtonTouchUpInsideEvent(_ sender: MultiStatableButton) {
        featureButton?.custom.toggle()

        onTap?()
    }
}
