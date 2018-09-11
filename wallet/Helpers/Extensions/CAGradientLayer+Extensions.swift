//
//  CAGradientLayer+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension CAGradientLayer {

    var image: UIImage? {

        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }

    static func generateDefaultHorizontalGradient(frame: CGRect) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.backgroundHorizontalDarker, UIColor.backgroundHorizontalLighter].map { $0.cgColor }

        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        return gradient
    }

}
