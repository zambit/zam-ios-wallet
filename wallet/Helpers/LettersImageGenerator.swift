//
//  LetterImage.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

/**
 A struct that generates image with character or pair of characters, using for example as avatar for non-avatar contacts.
 */
struct LettersImageGenerator {

    let bounds: CGRect

    func generate(string: String?,
                       color: UIColor? = nil,
                       circular: Bool = false,
                       textAttributes: [NSAttributedStringKey: Any]? = nil) -> UIImage? {

        let image = imageSnap(text: string != nil ? string?.initials : "",
                              color: color ?? .random,
                              circular: circular,
                              textAttributes:textAttributes)

        return image
    }

    private func imageSnap(text: String?,
                           color: UIColor,
                           circular: Bool,
                           textAttributes: [NSAttributedStringKey: Any]?) -> UIImage? {

        let scale = Float(UIScreen.main.scale)
        var size = bounds.size
            size.width = CGFloat(floorf((Float(size.width) * scale) / scale))
            size.height = CGFloat(floorf((Float(size.height) * scale) / scale))

        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(scale))
        let context = UIGraphicsGetCurrentContext()
        if circular {
            let path = CGPath(ellipseIn: bounds, transform: nil)
            context?.addPath(path)
            context?.clip()
        }

        // Fill
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        // Text
        if let text = text {
            let attributes = textAttributes ?? [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0)]

            let textSize = text.size(withAttributes: attributes)
            let bounds = self.bounds
            let rect = CGRect(x: bounds.size.width/2 - textSize.width/2, y: bounds.size.height/2 - textSize.height/2, width: textSize.width, height: textSize.height)

            text.draw(in: rect, withAttributes: attributes)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
