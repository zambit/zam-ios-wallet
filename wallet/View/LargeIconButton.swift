//
//  LargeIconButton.swift
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
class LargeIconButton: UIButton {

    private var iconView: UIView!

    var isLoading: Bool = false {
        didSet {
            // change iconView state
        }
    }

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
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
