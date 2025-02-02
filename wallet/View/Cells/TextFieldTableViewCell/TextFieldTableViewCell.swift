//
//  TextFieldTableViewCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate, Configurable {

    private var onTap: ((UITextField) -> Void)?
    private var onEditing: ((UITextField) -> Void)?
    private var onBegin: ((TextFieldTableViewCell) -> Void)?

    private(set) var textField: FloatTextField!

    private var indexPath: IndexPath?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupSubviews()
    }

    private func setupSubviews() {
        textField = FloatTextField()
        textField.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        textField.textColor = .darkIndigo
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

        contentView.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
    }

    func configure(with data: TextFieldTableViewCellData) {
        textField.custom.setup(placeholder: data.placeholder)
        textField.keyboardType = data.keyboardType ?? .default
        textField.autocapitalizationType = data.autocapitalizationType ?? .none
        textField.autocorrectionType = data.autocorrectionType ?? .default

        if let action = data.action {
            switch action {
            case .tap(action: let onTap):
                self.onTap = onTap
                self.onEditing = nil

            case .editingChanged(action: let onEditing):
                self.onEditing = onEditing
                self.onTap = nil
                textField.addTarget(self, action: #selector(onEditingEvent(_:)), for: .editingChanged)
            }
        }

        self.onBegin = data.beginEditingAction
        textField.delegate = self
    }

    func set(text: String) {
        self.textField.custom.setup(text: text)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let onTap = onTap {
            onTap(textField)
            return false
        }

        onBegin?(self)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc
    private func onEditingEvent(_ sender: UITextField) {
        onEditing?(sender)
    }
}
