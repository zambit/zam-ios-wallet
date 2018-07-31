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
class LargeIconButton: UIButton, CustomUI {

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

        func setLoading(_ enabled: Bool) {
            // to do
        }
    }

    var customAppearance: CustomAppearance {
        return CustomAppearance(parent: self)
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
        setImage(#imageLiteral(resourceName: "icArrowRight"), for: .disabled)
        setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)

        self.backgroundColor = .white
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
