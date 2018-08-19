//
//  SpinningAnimation.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class SpinningAnimationLayer: CAShapeLayer {

    init(frame: CGRect, color: UIColor, lineWidth: CGFloat = 2.0) {
        super.init()

        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: frame.size.width / 2,
                                        y: frame.size.height / 2),
                    radius: frame.size.width / 2,
                    startAngle: CGFloat(-3 * Double.pi / 4),
                    endAngle: CGFloat(-Double.pi / 4),
                    clockwise: false)

        self.path = path.cgPath
        self.frame = frame

        self.setupStyle(strokeColor: color, lineWidth: lineWidth)
        self.animate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
        self.animate()
    }

    private func setupStyle(strokeColor: UIColor = .cornflower, lineWidth: CGFloat = 2.0) {
        self.fillColor = nil
        self.backgroundColor = nil
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth

        self.lineJoin = kCALineJoinRound
        self.lineCap = kCALineCapRound
    }

    private func animate() {
        let duration: CFTimeInterval = 0.75

        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [rotateAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        self.add(animation, forKey: "animation")
    }

}
