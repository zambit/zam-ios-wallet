//
//  TextFieldCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TextFieldCell: UITableViewCell {

    private(set) var textField: UITextField!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupSubviews()
    }

    private func setupSubviews() {
        textField = UITextField()
        textField.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        textField.textColor = .darkIndigo
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textField.leftPadding = 16.0

        contentView.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
    }


}
