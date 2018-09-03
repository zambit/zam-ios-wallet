//
//  SegmentedControlButton.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class SegmentedControlElement {

    let selectedButton: UIButton
    let normalButton: UIButton

    let backColor: UIColor

    var mask: CALayer? {
        didSet {
            selectedButton.layer.mask = mask
        }
    }

    var center: CGPoint {
        get {
            return normalButton.center
        }

        set {
            normalButton.center = newValue
            selectedButton.center = newValue
        }
    }

    var width: CGFloat {
        return normalButton.bounds.width
    }

    var tag: Int {
        get {
            return normalButton.tag
        }

        set {
            normalButton.tag = newValue
            selectedButton.tag = newValue
        }
    }

    var isEnabled: Bool {
        get {
            return normalButton.isEnabled
        }

        set {
            normalButton.isEnabled = newValue
            selectedButton.isEnabled = newValue
        }
    }

    init(selected: UIButton, normal: UIButton, backColor: UIColor) {
        self.normalButton = normal
        self.selectedButton = selected

        self.backColor = backColor
    }

    func addTo(mainView: UIView, selectedView: UIView) {
        selectedView.addSubview(selectedButton)
        mainView.addSubview(normalButton)
    }

}
