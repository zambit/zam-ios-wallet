//
//  DoneAnimationLayer.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

open class CheckAnimationView: UIView {

    // MARK: - private variables

    fileprivate let lineLayer: CAShapeLayer = CAShapeLayer()

    // MARK: - public methods

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

    open func drawCheck(_ completion: (() -> Void)?) {
        let canvasFrame = CGRect(
            x: self.frame.width / 4,
            y: self.frame.height / 3,
            width: self.frame.width / 2,
            height: self.frame.height / 3)

        let path = UIBezierPath()
        path.move(
            to: CGPoint(x: canvasFrame.origin.x, y: canvasFrame.origin.y + canvasFrame.height / 2))
        path.addLine(
            to: CGPoint(x: canvasFrame.origin.x + canvasFrame.width / 3, y: canvasFrame.origin.y))
        path.addLine(
            to: CGPoint(x: canvasFrame.origin.x + canvasFrame.width, y: canvasFrame.origin.y + canvasFrame.height))
        self.lineLayer.frame = self.bounds
        self.lineLayer.isGeometryFlipped = true
        self.lineLayer.path = path.cgPath

        self.layer.addSublayer(self.lineLayer)
        self.animate(completion)
    }

    open func clear() {
        self.lineLayer.removeFromSuperlayer()
        self.lineLayer.removeAllAnimations()
        self.lineLayer.path = nil
    }

    // MARK: - private methods

    private func setupStyle(strokeColor: UIColor = .black, lineWidth: CGFloat = 8.0) {
        // Initialize properties
        self.clipsToBounds = true

        // Set default setting to line
        self.lineLayer.fillColor = UIColor.clear.cgColor
        self.lineLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.lineLayer.lineJoin = CAShapeLayerLineJoin.round
        self.lineLayer.lineCap = CAShapeLayerLineCap.round
        self.lineLayer.contentsScale = self.layer.contentsScale
        self.lineLayer.lineWidth = lineWidth
        self.lineLayer.strokeColor = strokeColor.cgColor
    }

    private func animate(_ completion: (() -> Void)?) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.3
        pathAnimation.fromValue = NSNumber(value: 0 as Float)
        pathAnimation.toValue = NSNumber(value: 1 as Float)
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock(completion)
        }
        self.lineLayer.add(pathAnimation, forKey:"strokeEndAnimation")
        CATransaction.commit()
    }
}
