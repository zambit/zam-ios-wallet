//
//  Text+IconButton.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Button appropriates large button from Onboarding screen. Blue title on middle. Blue arrow_icon on right. Roun corners. Size defines outside class.
 */
class LargeButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    private func setupStyle() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 28.0

        self.setTitleColor(.cornflower, for: .normal)

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.cornflower.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.3
    }

    private func setupLayouts() {
        guard let imageView = imageView else {
            return
        }

        imageEdgeInsets = UIEdgeInsets(top: 12.0, left: (bounds.width - 35.0 - 19.0), bottom: 12.0, right: 24.0)
        titleEdgeInsets = UIEdgeInsets(top: 19.0, left: 0, bottom: 19.0, right: imageView.frame.width + 24.0)
    }
}
