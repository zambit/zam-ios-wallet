//
//  MultiStatableButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class MultiStatableButton: UIButton {

    // MARK: - Custom behaviour data

    fileprivate var currentStateIndex: Int = 0
    fileprivate var colors: [UIColor?] = []
    fileprivate var backgroundColors: [UIColor?] = []
    fileprivate var images: [UIImage?] = []
    fileprivate var states: [String] = []

    // MARK: - Overrides
    override func tintColorDidChange() {
        if nil == currentColor {
            setTitleColor(tintColor, for: UIControl.State())
        }
    }

    // MARK: - Private
    fileprivate func setupCurrentState() {
        let currentTitle = states[currentStateIndex]
        setTitle(currentTitle.isEmpty ? nil : currentTitle, for: UIControl.State())
        setTitleColor(currentColor ?? tintColor, for: UIControl.State())
        backgroundColor = currentBackgroundColor ?? .clear
        setImage(currentToggleImage ?? currentImage, for: UIControl.State())
    }

    private var currentColor: UIColor? {
        return currentStateIndex < colors.count ? colors[currentStateIndex] : nil
    }

    private var currentBackgroundColor: UIColor? {
        return currentStateIndex < backgroundColors.count ? backgroundColors[currentStateIndex] : nil
    }

    private var currentToggleImage: UIImage? {
        return currentStateIndex < images.count ? images[currentStateIndex] : nil
    }
}

extension BehaviorExtension where Base: MultiStatableButton {

    func setup(images: [UIImage?],
               states: [String],
               colors: [UIColor?] = [],
               backgroundColors: [UIColor?] = []
        ) {

        if let image = images.first {
            base.setImage(image, for: UIControl.State())
        }

        base.sizeToFit()

        base.images = images
        base.states = states
        base.colors = colors
        base.backgroundColors = backgroundColors

        base.setupCurrentState()
    }

    func setup(
        image: UIImage? = nil,
        states: [String],
        colors: [UIColor?] = [],
        backgroundColors: [UIColor?] = []
        ) {
        self.setup(images: [image], states: states, colors: colors, backgroundColors: backgroundColors)
    }

    // MARK: - Manual Control

    func toggle() {
        self.currentStateIndex = (currentStateIndex + 1) % states.count
    }

    var currentStateIndex: Int {
        get {
            return base.currentStateIndex
        }

        set {
            base.currentStateIndex = newValue
            base.setupCurrentState()
        }
    }

    var colors: [UIColor?] {
        get {
            return base.colors
        }

        set {
            base.colors = newValue
            base.setupCurrentState()
        }
    }

    var backgroundColors: [UIColor?] {
        get {
            return base.backgroundColors
        }

        set {
            base.backgroundColors = newValue
            base.setupCurrentState()
        }
    }

    var images: [UIImage?] {
        get {
            return base.images
        }

        set {
            base.images = newValue
            base.setupCurrentState()
        }
    }

    var states: [String] {
        get {
            return base.states
        }

        set {
            base.states = newValue
            base.currentStateIndex %= newValue.count
            base.setupCurrentState()
        }
    }
}
