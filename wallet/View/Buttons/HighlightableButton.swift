//
//  HighlightableButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 14/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class HighlightableButton: UIButton {

    private var normalTintColor: UIColor?
    private var highlightedTintColor: UIColor?

    private var normalBackgroundColor: UIColor?
    private var highlightedBackgroundColor: UIColor?

    func setHighlightedTintColor(_ tintColor: UIColor) {
        self.normalTintColor = self.tintColor
        self.highlightedTintColor = tintColor
    }

    func setHighlightedBackgroundColor(_ backgroundColor: UIColor) {
        self.normalBackgroundColor = self.backgroundColor
        self.highlightedBackgroundColor = backgroundColor
    }

    override var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? highlightedTintColor : normalTintColor

            if let highlightedBackground = highlightedBackgroundColor {
                backgroundColor = isHighlighted ? highlightedBackground : normalBackgroundColor
            }
        }
    }
}
