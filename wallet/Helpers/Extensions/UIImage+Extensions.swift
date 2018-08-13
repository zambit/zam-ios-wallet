//
//  UIImage+Extensions.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func gradientImage(colors: [UIColor], locations: [NSNumber]?, frame: CGRect) -> UIImage {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations

        UIGraphicsBeginImageContext(frame.size)

        gradient.render(in: UIGraphicsGetCurrentContext()!)

        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage!
    }
}
