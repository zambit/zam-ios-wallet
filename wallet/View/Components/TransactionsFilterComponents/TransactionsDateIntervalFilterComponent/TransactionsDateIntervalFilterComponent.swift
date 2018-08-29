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

class TransactionsDateIntervalFilterComponent: CellComponent, UITextFieldDelegate {

    var onFilterChanged: ((Date?, Date?) -> Void)?

    weak var delegate: TransactionsDateIntervalFilterComponentDelegate?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var fromTextField: UITextField?
    @IBOutlet private var toTextField: UITextField?

    private var fromDate: Date?
    private var toDate: Date?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 325.0, height: 105.0 + insets.bottom + insets.top)
    }

    override func initFromNib() {
        super.initFromNib()

        fromTextField?.delegate = self
        toTextField?.delegate = self

        fromTextField?.tag = 6181513
        toTextField?.tag = 2015
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

    func prepare(from: Date? = nil, to: Date? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"

        if let from = from {
            fromTextField?.text = dateFormatter.string(from: from)
        } else {
            fromTextField?.text = ""
        }

        if let to = to {
            toTextField?.text = dateFormatter.string(from: to)
        } else {
            toTextField?.text = ""
        }

        fromDate = from
        toDate = to
    }

    private func checkForCompletion(from: Date?, to: Date?) {
        if let from = from, let to = to {
            delegate?.dateIntervalFilterComponentEditingCompleted(self, fromDate: from, toDate: to)
        }
    }

    @objc
    private func textFieldTouchUpInsideEvent(_ sender: UITextField) {
        let alert = UIAlertController(style: .actionSheet, title: "Select date")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) {
            [weak self]
            date in

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            sender.text = dateFormatter.string(from: date)

            switch sender.tag {
            case 6181513:
                self?.fromDate = date
            case 2015:
                self?.toDate = date
            default:
                fatalError()
            }
            
            self?.onFilterChanged?(self?.fromDate, self?.toDate)
            self?.checkForCompletion(from: self?.fromDate, to: self?.toDate)
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldTouchUpInsideEvent(textField)
        return false
    }
}
