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

    override var intrinsicContentSize: CGSize  {
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

        featureButton?.contentEdgeInsets = UIEdgeInsetsMake(8.0, 25.0, 8.0, 25.0)
        featureButton?.layer.borderWidth = 1.5
        featureButton?.layer.borderColor = UIColor.skyBlue.cgColor
        featureButton?.addTarget(self, action: #selector(featureButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func configure(title: String) {
        featureButton?.custom.setup(states: [title, title], colors: [UIColor.white, UIColor.white], backgroundColors: [.clear, .skyBlue])
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
