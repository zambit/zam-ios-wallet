//
//  ChartLayer.swift
//  wallet
//
//  Created by Alexander Ponomarev on 02/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class ChartLayer: CAShapeLayer {

    struct Point {
        var x: Double
        var y: Double
    }

    let size: CGSize
    let points: [Point]

    var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }

    private let defaultInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)

    init(size: CGSize, points: [Point] = []) {
        self.size = size
        self.points = points

        super.init()

        self.frame = CGRect(origin: .zero, size: size)

        setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        self.size = .zero
        self.points = []

        super.init(coder: aDecoder)
    }

    override func draw(in ctx: CGContext) {
        self.sublayers?.forEach {
            if $0.name == "strokeLayer" || $0.name == "gradientLayer" {
                $0.removeFromSuperlayer()
            }
        }
        
        guard !points.isEmpty else {
            return
        }

        let path = UIBezierPath()

        let widgetWidth = Double(size.width)
        let widgetHeight = Double(size.height - defaultInsets.bottom - defaultInsets.top - insets.bottom - insets.top)

        let xmax = points.max(by: { a, b in a.x < b.x })!.x
        let ymax = points.max(by: { a, b in a.y < b.y })!.y
        let xmin = points.min(by: { a, b in a.x < b.x })!.x
        let ymin = points.min(by: { a, b in a.y < b.y })!.y

        let xt = widgetWidth / (xmax - xmin)
        let yt = widgetHeight / (ymax - ymin)

        var interpolationPoints: [CGPoint] = []

        for p in points {
            let pathPointX = (p.x - xmin) * xt
            let pathPointY = Double(size.height) - ((p.y - ymin) * yt + Double(defaultInsets.bottom) + Double(insets.bottom))

            interpolationPoints.append(CGPoint(x: pathPointX,y: pathPointY))
        }

        // cubic interpolation of the graph
        path.interpolatePointsWithHermite(interpolationPoints: interpolationPoints)

        // closed path
        let closedPath = UIBezierPath(cgPath: path.cgPath)
        closedPath.addLine(to: CGPoint(x: size.width - insets.right - defaultInsets.right, y: size.height))
        closedPath.addLine(to: CGPoint(x: insets.left + defaultInsets.left, y: size.height))
        closedPath.close()

        // closed shape for filling
        let fillingShape = CAShapeLayer()
        fillingShape.frame = self.bounds
        fillingShape.path = closedPath.cgPath
        fillingShape.fillColor = UIColor.black.cgColor

        // gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.paleGrey, UIColor.white].map { $0.cgColor }
        gradientLayer.locations = [0.6, 1.0]
        gradientLayer.name = "gradientLayer"

        // make filling shape mask of gradient layer
        gradientLayer.mask = fillingShape

        addSublayer(gradientLayer)


        // stroke layer
        let strokeLayer = CAShapeLayer()
        strokeLayer.frame = self.bounds
        strokeLayer.path = path.cgPath
        strokeLayer.strokeColor = UIColor.lightblue.withAlphaComponent(0.25).cgColor
        strokeLayer.lineWidth = 1.0
        strokeLayer.fillColor = nil
        strokeLayer.name = "strokeLayer"

        addSublayer(strokeLayer)
    }
}
