//
//  UIView+Extensions.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIView {

    func applyDefaultGradient() {
        self.applyGradient(colors: [.backgroundDarker, .backgroundLighter])
    }
    
    func applyGradient(colors: [UIColor]) {
        self.applyGradient(colors: colors, locations: nil)
    }

    func applyGradient(colors: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
