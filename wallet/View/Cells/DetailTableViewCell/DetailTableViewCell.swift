//
//  DetailTableViewCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 19/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell, Configurable {

    private var titleLabel: UILabel!
    private var detailLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
        setupSubviews()
    }

    private func setupStyle() {
        self.backgroundColor = .clear
    }

    private func setupSubviews() {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .regular)
        titleLabel.textColor = .blueGrey
        titleLabel.textAlignment = .left

        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        self.titleLabel = titleLabel


        let detailLabel = UILabel()
        detailLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        detailLabel.textColor = .blueGrey
        detailLabel.textAlignment = .right
        detailLabel.lineBreakMode = .byTruncatingTail

        addSubview(detailLabel)

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -18.0).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10.0).isActive = true
        detailLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        self.detailLabel = detailLabel
    }

    func configure(with data: DetailTableViewCellData) {
        titleLabel.text = data.title
        detailLabel.text = data.detailValue
    }

}
