//
//  ChartView.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class ChartView: UIView {

    private var chartLayer: ChartLayer?
    private var panelView: UIView?

    var showAxis: Bool = false {
        didSet {
            chartLayer?.showAxis = showAxis
        }
    }

    var chartBorderWidth: CGFloat = 1.0 {
        didSet {
            chartLayer?.chartBorderWidth = chartBorderWidth
        }
    }

    var chartBorderColor: CGColor = UIColor.skyBlue.cgColor {
        didSet {
            chartLayer?.chartBorderColor = chartBorderColor
        }
    }

    var chartFillingGradientColors: [CGColor]? = nil {
        didSet {
            chartLayer?.chartFillingGradientColors = chartFillingGradientColors
        }
    }

    var insets: UIEdgeInsets = .zero {
        didSet {
            chartLayer?.insets = insets
        }
    }

    private lazy var panGestureRecognizer: InitiatedPanGestureRecognizer = {
        let panGestureRecognizer = InitiatedPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerEvent(_:)))
        return panGestureRecognizer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(panGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(panGestureRecognizer)
    }

    func setupChart(points: [ChartLayer.Coordinate]) {
        chartLayer?.removeFromSuperlayer()

        let layer = ChartLayer(size: self.size, points: points)
        layer.insets = insets
        layer.chartBorderColor = chartBorderColor
        layer.chartBorderWidth = chartBorderWidth
        layer.showAxis = showAxis
        layer.chartFillingGradientColors = chartFillingGradientColors

        self.chartLayer = layer
        self.layer.addSublayer(layer)
    }

    private var originalPoint: CGPoint = .zero

    @objc
    private func panGestureRecognizerEvent(_ sender: InitiatedPanGestureRecognizer) {
        switch sender.state {
        case .began:
            originalPoint = sender.initialLocation
            let translation = sender.translation(in: self)
            let point = CGPoint(x: originalPoint.x + translation.x, y: originalPoint.y + translation.y)
            chartLayer?.performChartSelection(for: point)
        case .changed:
            let translation = sender.translation(in: self)
            let point = CGPoint(x: originalPoint.x + translation.x, y: originalPoint.y + translation.y)
            //panelView?.frame.origin = CGPoint(x: translation.x + 15.0, y: translation.y - 70.0)
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            chartLayer?.performChartSelection(for: point)
            CATransaction.commit()
        default:
            return
        }
    }
}
