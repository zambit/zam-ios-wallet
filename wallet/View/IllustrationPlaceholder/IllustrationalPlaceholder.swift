//
//  TransactionsHistoryPlaceholder.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class IllustrationalPlaceholder: Component {

    enum SizingType {
        case small
        case normal
    }

    @IBOutlet private var illustrationImageView: UIImageView?
    @IBOutlet private var titleLabel: UILabel?

    @IBOutlet private var illustrationBottomConstraint: NSLayoutConstraint?
    @IBOutlet private var illustrationTopConstraint: NSLayoutConstraint?

    var sizingType: SizingType = .normal {
        didSet {
            switch sizingType {
            case .small:
                illustrationBottomConstraint?.constant = 10.0
                illustrationTopConstraint?.constant = 10.0
            case .normal:
                illustrationBottomConstraint?.constant = 20.0
                illustrationTopConstraint?.constant = 20.0
            }
        }
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        titleLabel?.textColor = .blueGrey
        titleLabel?.textAlignment = .center
        titleLabel?.text = "No data in this period"
        titleLabel?.sizeToFit()

        illustrationImageView?.image = #imageLiteral(resourceName: "illustrationPlaceholderDark")
    }

    var text: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
            titleLabel?.sizeToFit()
            layoutIfNeeded()
        }
    }

    var textColor: UIColor? {
        get {
            return titleLabel?.textColor
        }

        set {
            titleLabel?.textColor = newValue
        }
    }

    var font: UIFont? {
        get {
            return titleLabel?.font
        }

        set {
            titleLabel?.font = newValue
        }
    }
}
