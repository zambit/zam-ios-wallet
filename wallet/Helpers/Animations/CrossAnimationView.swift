//
//  CrossAnimationView.swift
//  wallet
//
//  Created by Александр Пономарев on 19.08.2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

open class CrossAnimationView: UIView {

    private let leftLayer: CAShapeLayer = CAShapeLayer()
    private let rightLayer: CAShapeLayer = CAShapeLayer()

    convenience init(frame: CGRect = .zero, strokeColor: UIColor, lineWidth: CGFloat) {
        self.init(frame: frame)
        self.setupStyle(strokeColor: strokeColor, lineWidth: lineWidth)
    }

    public init() {
        super.init(frame: CGRect.zero)
        self.setupStyle()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStyle()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }

    open func drawCross(_ completion: (() -> Void)?) {
        let canvasFrame = CGRect(
            x: self.frame.width / 4,
            y: self.frame.height / 4,
            width: self.frame.width / 2,
            height: self.frame.height / 2)

        let lpath = UIBezierPath()
        lpath.move(
            to: CGPoint(x: canvasFrame.origin.x + canvasFrame.width, y: canvasFrame.origin.y + canvasFrame.height))
        lpath.addLine(
            to: CGPoint(x: canvasFrame.origin.x, y: canvasFrame.origin.y))

        let rpath = UIBezierPath()
        rpath.move(to: CGPoint(x: canvasFrame.origin.x, y: canvasFrame.origin.y + canvasFrame.height))
        rpath.addLine(to: CGPoint(x: canvasFrame.origin.x + canvasFrame.width, y: canvasFrame.origin.y))

        self.leftLayer.frame = self.bounds
        self.leftLayer.isGeometryFlipped = true
        self.leftLayer.path = lpath.cgPath

        self.rightLayer.frame = self.bounds
        self.rightLayer.isGeometryFlipped = true
        self.rightLayer.path = rpath.cgPath

        self.layer.addSublayer(self.leftLayer)
        self.layer.addSublayer(self.rightLayer)
        self.animate(completion)
    }

    open func clear() {
        self.leftLayer.removeFromSuperlayer()
        self.leftLayer.removeAllAnimations()
        self.leftLayer.path = nil

        self.rightLayer.removeFromSuperlayer()
        self.rightLayer.removeAllAnimations()
        self.rightLayer.path = nil
    }

    // MARK: - Private methods

    private func setupStyle(strokeColor: UIColor = .black, lineWidth: CGFloat = 8.0) {
        self.clipsToBounds = true

        // Set default setting to line
        self.leftLayer.fillColor = UIColor.white.withAlphaComponent(0.0).cgColor
        self.leftLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.leftLayer.lineJoin = CAShapeLayerLineJoin.round
        self.leftLayer.lineCap = CAShapeLayerLineCap.round
        self.leftLayer.contentsScale = self.layer.contentsScale
        self.leftLayer.lineWidth = lineWidth
        self.leftLayer.strokeColor = strokeColor.cgColor

        self.rightLayer.fillColor = UIColor.white.withAlphaComponent(0.0).cgColor
        self.rightLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.rightLayer.lineJoin = CAShapeLayerLineJoin.round
        self.rightLayer.lineCap = CAShapeLayerLineCap.round
        self.rightLayer.contentsScale = self.layer.contentsScale
        self.rightLayer.lineWidth = lineWidth
        self.rightLayer.strokeColor = strokeColor.cgColor
    }

    private func animate(_ completion: (() -> Void)?) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.3
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock(completion)
        }
        self.leftLayer.add(pathAnimation, forKey:"strokeEndAnimation")
        self.rightLayer.add(pathAnimation, forKey:"strokeEndAnimation")

        CATransaction.commit()
    }
}
