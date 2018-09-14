//
//  HighlightableButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 14/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class HighlightableButton: UIButton {

    private var normalColor: UIColor?
    private var highlightedColor: UIColor?

    func setHighlightedTintColor(_ tintColor: UIColor) {
        self.normalColor = self.tintColor
        self.highlightedColor = tintColor
    }

    override var isHighlighted: Bool{
        didSet {
            tintColor = isHighlighted ? highlightedColor : normalColor
        }
    }
}
