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
class NextButton: UIButton {

    fileprivate var loadingView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        custom.setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setupStyle()
        custom.setupAnimationView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setupStyle()
        custom.setupAnimationView()
    }
}

extension BehaviorExtension where Base: NextButton {

    func setEnabled(_ enabled: Bool) {
        base.isUserInteractionEnabled = enabled

        switch enabled {
        case true:
            base.alpha = 1
        case false:
            base.alpha = 0.5
        }
    }

    func setLoading(_ enabled: Bool) {
        base.isUserInteractionEnabled = !enabled
        if enabled {
            base.setImage(#imageLiteral(resourceName: "icEmpty"), for: .normal)
        } else {
            base.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        }
        base.loadingView.isHidden = !enabled
    }

    fileprivate func setupStyle() {
        base.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .disabled)
        base.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)

        base.backgroundColor = .white

        base.layer.masksToBounds = false
        base.layer.shadowColor = UIColor.cornflower.cgColor
        base.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        base.layer.shadowRadius = 8.0
        base.layer.shadowOpacity = 0.3
    }

    fileprivate func setupLayouts() {
        base.layer.cornerRadius = base.bounds.width / 2
    }

    fileprivate func setupAnimationView() {
        let side: CGFloat = min(base.bounds.width, base.bounds.height) / 100 * 55

        let frame = CGRect(x: (base.bounds.width - side) / 2,
                           y: (base.bounds.height - side) / 2,
                           width: side,
                           height: side)
        base.loadingView = UIView(frame: frame)
        base.loadingView.layer.sublayers = nil

        let animationFrame = CGRect(x: 0,
                                    y: 0,
                                    width: side,
                                    height: side)
        let animation = SpinningAnimationLayer(frame: animationFrame, color: .cornflower)
        base.loadingView.layer.addSublayer(animation)
        base.loadingView.isHidden = true

        base.addSubview(base.loadingView)
    }
}
