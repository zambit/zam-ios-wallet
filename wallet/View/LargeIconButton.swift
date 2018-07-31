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

    struct CustomAppearance {
        weak var parent: LargeIconButton?

        func setEnabled(_ enabled: Bool) {
            parent?.isUserInteractionEnabled = enabled

            switch enabled {
            case true:
                parent?.alpha = 1
            case false:
                parent?.alpha = 0.5
            }
        }
    }

    private(set) var customAppearance: CustomAppearance!

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

        customAppearance = CustomAppearance(parent: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()

        customAppearance = CustomAppearance(parent: self)
    }

    private func setupStyle() {
        setImage(#imageLiteral(resourceName: "icArrowRight"), for: .disabled)
        setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)

        self.backgroundColor = .white
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
