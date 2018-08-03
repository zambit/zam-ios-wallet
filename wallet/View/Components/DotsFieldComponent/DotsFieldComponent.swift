//
//  DotsFieldComponent.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DotsFieldComponent: Component {

    @IBOutlet private var dotsStackView: UIStackView?

    private var dotEdge: CGFloat = 0.0
    private var dotSpacing: CGFloat = 0.0

    var dotsCount: Int = 4 {
        didSet {
            dotsStackView?.arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }

            setupDots(count: dotsCount, edge: dotEdge, spacing: dotSpacing)
        }
    }

    private(set) var currentDotIndex: Int = 0 {
        didSet {
            print("Current: \(currentDotIndex)")
        }
    }

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
            //...
            break
        case .extra, .medium:
            dotEdge = 16.0
            dotSpacing = 24.0
        case .plus:
            //....
            break
        case .unknown:
            break
        }

        setupDots(count: dotsCount, edge: dotEdge, spacing: dotSpacing)
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

    func fillLast() {
        guard currentDotIndex < dotsCount else {
            return
        }

        dots[currentDotIndex].customAppearance.setStyle(.filled)
        currentDotIndex += 1
    }

    func unfillLast() {
        guard currentDotIndex > 0 else {
            return
        }

        currentDotIndex -= 1
        dots[currentDotIndex].customAppearance.setStyle(.empty)
    }

    func fillGreenAll() {
        guard let dots = dotsStackView?.arrangedSubviews as? [DotView] else {
            fatalError()
        }

        dots.forEach {
            $0.customAppearance.setStyle(.green)
        }
    }

    func fillRedAll() {
        guard let dots = dotsStackView?.arrangedSubviews as? [DotView] else {
            fatalError()
        }

        dots.forEach {
            $0.customAppearance.setStyle(.red)
        }
    }
}
