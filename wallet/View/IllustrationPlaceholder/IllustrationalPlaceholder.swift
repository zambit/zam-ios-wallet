//
//  TransactionsHistoryPlaceholder.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class IllustrationalPlaceholder: Component, SizePresetable {

    @IBOutlet private var illustrationImageView: UIImageView?
    @IBOutlet private var titleLabel: UILabel?

    @IBOutlet private var illustrationBottomConstraint: NSLayoutConstraint?
    @IBOutlet private var illustrationTopConstraint: NSLayoutConstraint?

    private var bottomConstant: CGFloat = 0.0

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        titleLabel?.textColor = .blueGrey
        titleLabel?.textAlignment = .center
        titleLabel?.text = "No data in this period"
        titleLabel?.sizeToFit()

        illustrationImageView?.image = #imageLiteral(resourceName: "illustrationPlaceholderDark")
    }

    func prepare(preset: SizePreset) {
        switch preset {
        case .superCompact:
            illustrationBottomConstraint?.constant = 5.0
            illustrationTopConstraint?.constant = 0.0
            bottomConstant = -5.0
        case .compact, .default:
            illustrationBottomConstraint?.constant = 10.0
            illustrationTopConstraint?.constant = 0.0
            bottomConstant = -5.0
        }
    }

    var image: UIImage? {
        get {
            return illustrationImageView?.image
        }

        set {
            illustrationImageView?.image = newValue

        }
    }

    var text: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
            titleLabel?.sizeToFit()

            if let text = newValue, !text.isEmpty {
                illustrationBottomConstraint?.constant = bottomConstant
                layoutIfNeeded()
            }
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
