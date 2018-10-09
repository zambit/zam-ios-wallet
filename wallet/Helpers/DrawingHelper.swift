//
//  Drawing.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

struct DrawingHelper {

    static func drawSeparator(in view: UIView, center: CGPoint, width: CGFloat) {
        let height: CGFloat = 1.0

        let origin = CGPoint(x: center.x - width / 2, y: center.y - height / 2)

        let rect = CGRect(origin: origin, size: CGSize(width: width, height: height))
        let separator = UIView(frame: rect)

        separator.backgroundColor = UIColor.warmGrey.withAlphaComponent(0.2)
        separator.tag = 102

        if let anotherView = view.viewWithTag(102) {
            anotherView.removeFromSuperview()
        }
        view.addSubview(separator)
        separator.autoresizingMask = [.flexibleWidth]
    }

    static func drawIndicator(in view: UIView, center: CGPoint) {
        let width: CGFloat = 48.0
        let height: CGFloat = 4.0

        let origin = CGPoint(x: center.x - width / 2, y: center.y - height / 2)

        let rect = CGRect(origin: origin, size: CGSize(width: width, height: height))
        let indicator = UIView(frame: rect)

        indicator.layer.cornerRadius = height / 2
        indicator.backgroundColor = .lightPeriwinkle
        indicator.tag = 101

        if let anotherView = view.viewWithTag(101) {
            anotherView.removeFromSuperview()
        }
        view.addSubview(indicator)
    }

    static func dragIndicator() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 48, height: 4))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.lightPeriwinkle.cgColor)

            let rectangle = CGRect(x: 0, y: 0, width: 48, height: 4)
            let path = UIBezierPath(roundedRect: rectangle, cornerRadius: 2).cgPath
            ctx.cgContext.addPath(path)

            ctx.cgContext.closePath()
            ctx.cgContext.fillPath()
        }
        return img
    }
}
