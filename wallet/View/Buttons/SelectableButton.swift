//
//  SelectableButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class SelectableButton: UIButton {

    private var normalBackgroundColor: UIColor?
    private var selectedBackgroundColor: UIColor?

    func setSelectedBackgroundColor(_ backgroundColor: UIColor) {
        self.normalBackgroundColor = self.backgroundColor
        self.selectedBackgroundColor = backgroundColor
    }

    override var isSelected: Bool {
        didSet {
            if let selectedBackground = selectedBackgroundColor {
                backgroundColor = isSelected ? selectedBackground : normalBackgroundColor
            }
        }
    }
}

