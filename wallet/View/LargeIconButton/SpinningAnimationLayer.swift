//
//  SpinningAnimation.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class SpinningAnimationLayer: CAShapeLayer {

    private let size: CGSize
    private let color: UIColor

    init(frame: CGRect, color: UIColor) {
        self.size = frame.size
        self.color = color

        super.init()

        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: size.width / 2,
                                        y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(-3 * Double.pi / 4),
                    endAngle: CGFloat(-Double.pi / 4),
                    clockwise: false)

        self.fillColor = nil
        self.strokeColor = color.cgColor
        self.lineWidth = 2

        self.backgroundColor = nil
        self.path = path.cgPath
        self.frame = frame

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
