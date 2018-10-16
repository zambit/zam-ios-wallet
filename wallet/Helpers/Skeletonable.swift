//
//  Skeletonable.swift
//  wallet
//
//  Created by Alexander Ponomarev on 15/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol Skeletonable {

    var skeletonBackgroundColor: CGColor { get }

    var skeletonMovingColor: CGColor { get }

    func stiffen()

    func relive()
}

extension UIView: Skeletonable {

    var skeletonBackgroundColor: CGColor {
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor
    }

    var skeletonMovingColor: CGColor {
        return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
    }

    @objc
    func stiffen() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = self.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity

        let gradient = self.gradientLayer

        self.layer.addSublayer(gradient)
        gradient.add(animationGroup, forKey: animation.keyPath)
    }

    @objc
    func relive() {
        gradientLayer.removeAllAnimations()
        gradientLayer.removeFromSuperlayer()
    }

    private var startLocations: [NSNumber] {
        return [-1.0,-0.5, 0.0]
    }

    private var endLocations: [NSNumber] {
        return [1.0, 1.5, 2.0]
    }

    private var movingAnimationDuration: CFTimeInterval {
        return 0.8
    }

    private var delayBetweenAnimationLoops: CFTimeInterval {
        return 1.0
    }

    var gradientLayer: CAGradientLayer {
        if let gradientLayer = layer.sublayers?.first(where: { $0.name == "skeletonGradientLayer" }) as? CAGradientLayer {
            return gradientLayer
        }

        let gradientLayer = CAGradientLayer()

        gradientLayer.name = "skeletonGradientLayer"
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            skeletonBackgroundColor,
            skeletonMovingColor,
            skeletonBackgroundColor
        ]
        gradientLayer.locations = self.startLocations
        gradientLayer.cornerRadius = 6.0

        return gradientLayer
    }
}
