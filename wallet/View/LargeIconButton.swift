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
 Button appropriates large button from Onboarding screen. Blue title on middle. Blue arrow_icon on right. Round corners. Size defines outside class.
 */
class LargeIconButton: UIButton, CustomUI {

    private var loadingView: UIView!

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
            parent?.isUserInteractionEnabled = !enabled
            if enabled {
                parent?.setImage(#imageLiteral(resourceName: "empty_icon"), for: .normal)
            } else {
                parent?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
            }
            parent?.loadingView.isHidden = !enabled
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
        setupAnimationView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
        setupAnimationView()
    }

    private func setupStyle() {
        setImage(#imageLiteral(resourceName: "icArrowRight"), for: .disabled)
        setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)

        self.backgroundColor = .white

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.cornflower.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.3
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }

    private func setupAnimationView() {
        let side: CGFloat = min(bounds.width, bounds.height) / 100 * 55

        let frame = CGRect(x: (bounds.width - side) / 2,
                           y: (bounds.height - side) / 2,
                           width: side,
                           height: side)
        self.loadingView = UIView(frame: frame)
        self.loadingView.layer.sublayers = nil

        let animationFrame = CGRect(x: 0,
                                    y: 0,
                                    width: side,
                                    height: side)
        let animation = SpinningAnimationLayer(frame: animationFrame, color: .cornflower)
        self.loadingView.layer.addSublayer(animation)
        self.loadingView.isHidden = true

        self.addSubview(loadingView)
    }
}
