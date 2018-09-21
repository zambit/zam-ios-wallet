//
//  DecimalButton.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DecimalButton: UIButton, CustomUI {

    struct CustomBehaviour {
        weak var parent: DecimalButton?

        var id: String? {
            return parent?.id
        }

        func setDecimal(_ decimal: String) {
            guard let parent = parent else {
                return
            }

            parent.id = decimal
            let attributedString = NSAttributedString(string: decimal, attributes: parent.titleAttributes)
            parent.setAttributedTitle(attributedString, for: .normal)
        }

        func setIcon(_ icon: UIImage, id: String) {
            parent?.id = id

            parent?.setAttributedTitle(nil, for: .normal)
            parent?.setImage(icon, for: .normal)

            parent?.layer.borderWidth = 0

            parent?.highlightedBackgroundColor = .clear
        }

        func setEmpty() {
            parent?.setAttributedTitle(nil, for: .normal)
            parent?.setImage(nil, for: .normal)

            parent?.layer.borderWidth = 0

            parent?.highlightedBackgroundColor = .clear
        }
    }

    var custom: CustomBehaviour {
        return CustomBehaviour(parent: self)
    }

    var id: String?

    var normalBackgroundColor: UIColor = .clear
    var highlightedBackgroundColor: UIColor = UIColor.cornflower.withAlphaComponent(0.1)
    var highlightedTintColor: UIColor = UIColor.cornflower.withAlphaComponent(0.04)

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
            imageView?.tintColor = isHighlighted ? highlightedTintColor : nil
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    private func setupStyle() {
        self.backgroundColor = normalBackgroundColor

        self.layer.masksToBounds = false
        self.layer.borderWidth = 2
        self.layer.borderColor = highlightedBackgroundColor.cgColor
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
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
