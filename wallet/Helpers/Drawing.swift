//
//  Drawing.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

func drawIndicator(in view: UIView, center: CGPoint) {
    let width: CGFloat = 48.0
    let height: CGFloat = 4.0

    let origin = CGPoint(x: center.x - width / 2, y: center.y - height / 2)

    let rect = CGRect(origin: origin, size: CGSize(width: width, height: height))
    let indicator = UIView(frame: rect)

    indicator.layer.cornerRadius = height / 2
    indicator.backgroundColor = .lightPeriwinkle

    view.addSubview(indicator)
}

func dragIndicator() -> UIImage {
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
