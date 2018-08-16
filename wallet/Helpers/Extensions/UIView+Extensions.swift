//
//  UIView+Extensions.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIView {

    func applyDefaultGradient(frame: CGRect) {
        self.applyGradient(colors: [.backgroundDarker, .backgroundLighter], frame: frame)
    }

    func applyDefaultGradient() {
        self.applyGradient(colors: [.backgroundDarker, .backgroundLighter])
    }

    func applyDefaultGradientHorizontally() {
        self.applyGradient(colors: [.backgroundDarker, .backgroundLighter], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, frame: CGRect? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame ?? bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations

        if let startPoint = startPoint, let endPoint = endPoint {
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
