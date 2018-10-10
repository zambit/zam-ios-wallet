//
//  SpinningAnimationView.swift
//  wallet
//
//  Created by Alexander Ponomarev on 09/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

open class SpinningAnimationView: UIView {

    private var spinningLayer: SpinningAnimationLayer!

    convenience init(frame: CGRect = .zero, strokeColor: UIColor, lineWidth: CGFloat) {
        self.init(frame: frame)
        self.setupStyle(strokeColor: strokeColor, lineWidth: lineWidth)
    }

    public init() {
        super.init(frame: CGRect.zero)
        self.setupStyle()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStyle()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }

    open func beginSpinning() {
        self.layer.addSublayer(spinningLayer)
        self.spinningLayer.animate()
    }

    open func clear() {
        self.spinningLayer.removeFromSuperlayer()
        self.spinningLayer.removeAllAnimations()
    }

    // MARK: - Private methods

    private func setupStyle(strokeColor: UIColor = .black, lineWidth: CGFloat = 8.0) {
        self.clipsToBounds = true

        // Assign layer object
        self.spinningLayer = SpinningAnimationLayer(frame: frame, color: strokeColor, lineWidth: lineWidth)
    }
}
