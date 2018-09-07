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

    @IBOutlet private var illustrationImageView: UIImageView?
    @IBOutlet private var titleLabel: UILabel?

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
}
