//
//  DotView.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DotView: UIView {

    enum Style {
        case empty, filled, red, green
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        custom.setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setupStyle()
    }
}

extension BehaviorExtension where Base: DotView {

    func setStyle(_ style: DotView.Style) {
        switch style {
        case .empty:
            base.backgroundColor = .clear
            base.layer.borderWidth = 1.0
            base.layer.borderColor = UIColor.cornflower.cgColor

        case .filled:
            base.backgroundColor = .cornflower
            base.layer.borderWidth = 0.0

        case .red:
            base.backgroundColor = .error
            base.layer.borderWidth = 0.0

            base.layer.shadowColor = UIColor.error.cgColor
            base.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            base.layer.shadowRadius = 8.0
            base.layer.shadowOpacity = 0.3

        case .green:
            base.backgroundColor = .weirdGreen
            base.layer.borderWidth = 0.0

            base.layer.shadowColor = UIColor.weirdGreen.cgColor
            base.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            base.layer.shadowRadius = 8.0
            base.layer.shadowOpacity = 0.3
        }
    }

    fileprivate func setupStyle() {
        base.backgroundColor = .clear

        base.layer.masksToBounds = false
        setStyle(.empty)
    }

    fileprivate func setupLayouts() {
        base.layer.cornerRadius = base.bounds.width / 2
    }
}
