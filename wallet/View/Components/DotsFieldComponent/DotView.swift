//
//  DotView.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DotView: UIView, CustomUI {

    struct CustomBehaviour {

        enum Style {
            case empty, filled, red, green
        }

        weak var parent: DotView?

        func setStyle(_ style: Style) {
            switch style {
            case .empty:
                parent?.backgroundColor = .clear
                parent?.layer.borderWidth = 1.0
                parent?.layer.borderColor = UIColor.cornflower.cgColor

            case .filled:
                parent?.backgroundColor = .cornflower
                parent?.layer.borderWidth = 0.0

            case .red:
                parent?.backgroundColor = .error
                parent?.layer.borderWidth = 0.0

                parent?.layer.shadowColor = UIColor.error.cgColor
                parent?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                parent?.layer.shadowRadius = 8.0
                parent?.layer.shadowOpacity = 0.3

            case .green:
                parent?.backgroundColor = .weirdGreen
                parent?.layer.borderWidth = 0.0

                parent?.layer.shadowColor = UIColor.weirdGreen.cgColor
                parent?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                parent?.layer.shadowRadius = 8.0
                parent?.layer.shadowOpacity = 0.3
            }
        }
    }

    var custom: CustomBehaviour {
        return CustomBehaviour(parent: self)
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
        self.backgroundColor = .clear

        self.layer.masksToBounds = false
        custom.setStyle(.empty)
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
