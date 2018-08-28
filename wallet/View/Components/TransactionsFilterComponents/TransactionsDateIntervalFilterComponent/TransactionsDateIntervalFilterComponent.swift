//
//  TransactionsDateIntervalFilterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit


protocol TransactionsDateIntervalFilterComponentDelegate: class {

    func dateIntervalFilterComponentEditingCompleted(_ dateIntervalFilterComponent: TransactionsDateIntervalFilterComponent, fromDate: Date, toDate: Date)

}

class TransactionsDateIntervalFilterComponent: CellComponent {

    weak var delegate: TransactionsDateIntervalFilterComponentDelegate?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var fromTextField: UITextField?
    @IBOutlet private var toTextField: UITextField?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 325.0, height: 105.0 + insets.bottom + insets.top)
    }

    override func initFromNib() {
        super.initFromNib()
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textAlignment = .left

        fromTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        fromTextField?.font = UIFont.walletFont(ofSize: 18, weight: .medium)
        fromTextField?.attributedPlaceholder = NSAttributedString(string: "From", attributes: [.font: UIFont.walletFont(ofSize: 18, weight: .medium), .foregroundColor: UIColor.blueGrey])
        fromTextField?.textColor = .white
        fromTextField?.leftPadding = 16.0
        fromTextField?.rightPadding = 16.0
        fromTextField?.layer.cornerRadius = 8.0

        toTextField?.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        toTextField?.font = UIFont.walletFont(ofSize: 18, weight: .medium)
        toTextField?.attributedPlaceholder = NSAttributedString(string: "To", attributes: [.font: UIFont.walletFont(ofSize: 18, weight: .medium), .foregroundColor: UIColor.blueGrey])
        toTextField?.textColor = .white
        toTextField?.leftPadding = 16.0
        toTextField?.rightPadding = 16.0
        toTextField?.layer.cornerRadius = 8.0
    }

    func setTitle(_ title: String) {
        titleLabel?.text = title
    }

}
