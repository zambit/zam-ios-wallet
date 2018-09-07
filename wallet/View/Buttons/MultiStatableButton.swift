//
//  MultiStatableButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class MultiStatableButton: UIButton, CustomUI {

    struct CustomBehaviour {
        weak var parent: MultiStatableButton?

        func setup(images: [UIImage?],
                   states: [String],
                   colors: [UIColor?] = [],
                   backgroundColors: [UIColor?] = []
            ) {

            if let image = images.first {
                parent?.setImage(image, for: UIControlState())
            }
            parent?.sizeToFit()

            parent?.images = images
            parent?.states = states
            parent?.colors = colors
            parent?.backgroundColors = backgroundColors

            parent?.setupCurrentState()
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
                return parent!.currentStateIndex
            }

            nonmutating set {
                parent!.currentStateIndex = newValue
                parent!.setupCurrentState()
            }
        }

        var colors: [UIColor?] {
            get {
                return parent!.colors
            }

            nonmutating set {
                parent!.colors = newValue
                parent!.setupCurrentState()
            }
        }

        var backgroundColors: [UIColor?] {
            get {
                return parent!.backgroundColors
            }

            nonmutating set {
                parent!.backgroundColors = newValue
                parent!.setupCurrentState()
            }
        }

        var images: [UIImage?] {
            get {
                return parent!.images
            }

            nonmutating set {
                parent!.images = newValue
                parent!.setupCurrentState()
            }
        }

        var states: [String] {
            get {
                return parent!.states
            }

            nonmutating set {
                parent!.states = newValue
                parent!.currentStateIndex %= newValue.count
                parent!.setupCurrentState()
            }
        }
    }

    var custom: MultiStatableButton.CustomBehaviour {
        return CustomBehaviour(parent: self)
    }

    // MARK: - Custom behaviour data

    private var currentStateIndex: Int = 0
    private var colors: [UIColor?] = []
    private var backgroundColors: [UIColor?] = []
    private var images: [UIImage?] = []
    private var states: [String] = []

    // MARK: - Overrides
    override func tintColorDidChange() {
        if nil == currentColor {
            setTitleColor(tintColor, for: UIControlState())
        }
    }

    // MARK: - Private
    private func setupCurrentState() {
        let currentTitle = states[currentStateIndex]
        setTitle(currentTitle.isEmpty ? nil : currentTitle, for: UIControlState())
        setTitleColor(currentColor ?? tintColor, for: UIControlState())
        backgroundColor = currentBackgroundColor ?? .clear
        setImage(currentToggleImage ?? currentImage, for: UIControlState())
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
