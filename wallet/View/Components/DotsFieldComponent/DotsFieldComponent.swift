//
//  DotsFieldComponent.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DotsFieldComponent: Component  {

    @IBOutlet private var dotsStackView: UIStackView?

    private var dotEdge: CGFloat = 0.0
    private var dotSpacing: CGFloat = 0.0

    var dotsMaxCount: Int = 4 {
        didSet {
            dotsStackView?.arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }

            setupDots(count: dotsMaxCount, edge: dotEdge, spacing: dotSpacing)
        }
    }

    var filledCount: Int {
        return currentDotIndex
    }

    var fillingEnabled: Bool = true

    private(set) var currentDotIndex: Int = 0

    private var dots: [DotView] {
        guard let dotsStack = dotsStackView?.arrangedSubviews as? [DotView] else {
            fatalError()
        }

        return dotsStack
    }

    override func initFromNib() {
        super.initFromNib()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            dotEdge = 16.0
            dotSpacing = 24.0
            break
        case .extra, .extraLarge, .medium, .plus:
            dotEdge = 16.0
            dotSpacing = 24.0
        case .unknown:
            break
        }

        setupDots(count: dotsMaxCount, edge: dotEdge, spacing: dotSpacing)
    }

    override func setupStyle() {
        super.setupStyle()
    }

    private func setupDots(count: Int, edge: CGFloat, spacing: CGFloat) {
        dotsStackView?.alignment = .fill
        dotsStackView?.axis = .horizontal
        dotsStackView?.distribution = .equalSpacing
        dotsStackView?.spacing = spacing

        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: 16.0, height: 16.0))
        for _ in 0..<count {
            let dot = DotView(frame: rect)
                dot.widthAnchor.constraint(equalToConstant: dotEdge).isActive = true
                dot.heightAnchor.constraint(equalTo: dot.widthAnchor).isActive = true
            dotsStackView?.addArrangedSubview(dot)
        }
    }

    @discardableResult
    func fillLast() -> Bool {
        guard currentDotIndex < dotsMaxCount, fillingEnabled else {
            return false
        }

        dots[currentDotIndex].custom.setStyle(.filled)
        currentDotIndex += 1

        return true
    }

    @discardableResult
    func unfillLast() -> Bool {
        guard currentDotIndex > 0, fillingEnabled else {
            return false
        }

        currentDotIndex -= 1
        dots[currentDotIndex].custom.setStyle(.empty)

        return true
    }

    func unfillAll() {
        dots.forEach {
            $0.custom.setStyle(.empty)
        }

        currentDotIndex = 0
    }

    func fillAll() {
        dots.forEach {
            $0.custom.setStyle(.filled)
        }

        currentDotIndex = dotsMaxCount - 1
    }

    func showSuccess() {
        guard let dots = dotsStackView?.arrangedSubviews as? [DotView] else {
            fatalError()
        }

        dots.forEach {
            $0.custom.setStyle(.green)
        }
    }

    func showFailure(completion handler: @escaping () -> Void) {
        guard let dots = dotsStackView?.arrangedSubviews as? [DotView] else {
            fatalError()
        }

        dots.forEach {
            $0.custom.setStyle(.red)
        }

        animateFailure(completion: handler)
    }

    private func animateFailure(completion handler: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(handler)

        let duration: Float = 0.2
        let repeatCount: Float = 3

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = TimeInterval(duration)/TimeInterval(repeatCount)
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        self.layer.add(animation, forKey: "position")

        CATransaction.commit()
    }
}
