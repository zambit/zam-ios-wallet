//
//  DecimalButton.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DecimalButton: UIButton {

    fileprivate var id: String?

    fileprivate var normalBackgroundColor: UIColor = .clear
    fileprivate var highlightedBackgroundColor: UIColor = UIColor.cornflower.withAlphaComponent(0.1)
    fileprivate var highlightedTintColor: UIColor = UIColor.cornflower.withAlphaComponent(0.04)

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
            imageView?.tintColor = isHighlighted ? highlightedTintColor : nil
        }
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

extension BehaviorExtension where Base: DecimalButton {

    var id: String? {
        return base.id
    }

    func setDecimal(_ decimal: String) {
        base.id = decimal
        let attributedString = NSAttributedString(string: decimal, attributes: titleAttributes)
        base.setAttributedTitle(attributedString, for: .normal)
    }

    func setIcon(_ icon: UIImage, id: String) {
        base.id = id

        base.setAttributedTitle(nil, for: .normal)
        base.setImage(icon, for: .normal)

        base.layer.borderWidth = 0

        base.highlightedBackgroundColor = .clear
    }

    func setEmpty() {
        base.setAttributedTitle(nil, for: .normal)
        base.setImage(nil, for: .normal)

        base.layer.borderWidth = 0

        base.highlightedBackgroundColor = .clear
    }

    fileprivate func setupStyle() {
        base.backgroundColor = base.normalBackgroundColor

        base.layer.masksToBounds = false
        base.layer.borderWidth = 2
        base.layer.borderColor = base.highlightedBackgroundColor.cgColor
    }

    fileprivate func setupLayouts() {
        base.layer.cornerRadius = base.bounds.width / 2
    }

    private var titleAttributes: [NSAttributedString.Key: Any] {
        let font = UIFont.systemFont(ofSize: 34.0, weight: .regular)
        let color = UIColor.white
        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
    }
}
