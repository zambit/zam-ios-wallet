//
//  ChartLayer.swift
//  wallet
//
//  Created by Alexander Ponomarev on 02/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class ChartLayer: CALayer {

    struct Coordinate {
        var x: Double
        var y: Double
    }

    let size: CGSize
    let points: [Coordinate]

    var showAxis: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var chartBorderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var chartBorderColor: CGColor = UIColor.skyBlue.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }

    var chartFillingGradientColors: [CGColor]? = nil {
        didSet {
            setNeedsDisplay()
        }
    }

    var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    private let defaultInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)

    private lazy var dotLayer: CAShapeLayer = {
        let dot = CAShapeLayer()
        dot.strokeColor = UIColor.lightishGreen.cgColor
        dot.fillColor = UIColor.white.cgColor
        dot.lineWidth = 2.0
        dot.name = "dotLayer"
        addSublayer(dot)

        return dot
    }()

    private var chartPoints: [CGPoint] = []

    init(size: CGSize, points: [Coordinate] = []) {
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
        self.chartPoints = path.interpolatePointsWithHermite(interpolationPoints: interpolationPoints)

        if showAxis {
            let verticalSpacing: CGFloat = 25.0
            let linesCount = Int(floorf(Float(path.bounds.height / verticalSpacing)))

            let valueSpacing = (ymax - ymin)/Double(linesCount)

            var curVerticalPosition: CGFloat = defaultInsets.top + insets.top
            var curValue: Double = ymax

            while curVerticalPosition <= path.bounds.height + defaultInsets.top + insets.top  {
                let from = CGPoint(x: insets.left + defaultInsets.left, y: curVerticalPosition)
                let to = CGPoint(x: size.width - insets.right - defaultInsets.right, y: curVerticalPosition)

                let path = UIBezierPath()
                path.move(to: from)
                path.addLine(to: to)

                let axisLayer = CAShapeLayer()
                axisLayer.frame = bounds
                axisLayer.path = path.cgPath
                axisLayer.lineWidth = 1.0
                axisLayer.strokeColor = UIColor.black.withAlphaComponent(0.05).cgColor

//                NSAttributedString(string: String(curValue), attributes: [.font : UIFont.walletFont(ofSize: 10, weight: .regular), .foregroundColor: UIColor.black.withAlphaComponent(0.1).cgColor])

                let textLayer = CATextLayer()
                textLayer.string = NumberFormatter.walletAmountShort.string(from: curValue as NSNumber)
                textLayer.frame = CGRect(x: to.x - 65.0, y: curVerticalPosition - 15.0, width: 60.0, height: 15.0)
                textLayer.alignmentMode = .right
                textLayer.font = UIFont.walletFont(ofSize: 10, weight: .regular)
                textLayer.fontSize = 10
                textLayer.foregroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.isWrapped = true

                curVerticalPosition += verticalSpacing
                curValue -= valueSpacing

                addSublayer(axisLayer)
                addSublayer(textLayer)
            }
        }

        if let chartFillingGradientColors = self.chartFillingGradientColors {
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
            gradientLayer.colors = chartFillingGradientColors
            gradientLayer.locations = [0.6, 1.0]
            gradientLayer.name = "gradientLayer"

            // make filling shape mask of gradient layer
            gradientLayer.mask = fillingShape

            addSublayer(gradientLayer)
        }

        // stroke layer
        let strokeLayer = CAShapeLayer()
        strokeLayer.frame = self.bounds
        strokeLayer.path = path.cgPath
        strokeLayer.strokeColor = chartBorderColor
        strokeLayer.lineWidth = chartBorderWidth
        strokeLayer.fillColor = nil
        strokeLayer.name = "strokeLayer"

        addSublayer(strokeLayer)
    }

    func performChartSelection(for point: CGPoint) {
        let _index = chartPoints.firstIndex(where: {
            $0.x >= point.x
        })

        guard let index = _index else {
            return
        }

        let dotPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: chartPoints[index].x - 5, y: chartPoints[index].y - 5), size: CGSize(width: 10, height: 10)))
        dotLayer.path = dotPath.cgPath
    }
}
