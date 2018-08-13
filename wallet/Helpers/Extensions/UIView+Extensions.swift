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

    func applyGradient(colors: [UIColor], frame: CGRect? = nil) {
        self.applyGradient(colors: colors, locations: nil, frame: frame ?? bounds)
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]?, frame: CGRect? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame ?? bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
