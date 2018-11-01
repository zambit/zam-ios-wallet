//
//  WalletDetailsSwitcherTableViewCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 31/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol WalletDetailsSwitcherDelegate: class {

    func walletDetailsSwitcher(_ walletDetailsSwitcher: WalletDetailsSwitcherTableViewCell, buttonSelected: WalletDetailsSwitcherViewData.ChoiceType)
}

class WalletDetailsSwitcherTableViewCell: UITableViewCell, Configurable {

    weak var delegate: WalletDetailsSwitcherDelegate?

    private var leftButton: SelectableButton!
    private var rightButton: SelectableButton!

    override func prepareForReuse() {
        leftButton?.isSelected = false
        rightButton?.isSelected = false
    }

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
        self.backgroundColor = .white
    }

    private func setupSubviews() {
        self.hero.isEnabled = true
        self.hero.modifiers = [.fade]

        let leftButton = SelectableButton(type: .custom)
        leftButton.titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        leftButton.setTitleColor(.silver, for: .normal)
        leftButton.setTitleColor(.darkIndigo, for: .selected)
        leftButton.setImage(nil, for: .normal)
        leftButton.backgroundColor = .clear
        leftButton.addTarget(self, action: #selector(leftButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.addSubview(leftButton)

        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 18.0).isActive = true
        leftButton.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true

        self.leftButton = leftButton


        let rightButton = SelectableButton(type: .custom)
        rightButton.titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        rightButton.setTitleColor(.silver, for: .normal)
        rightButton.setTitleColor(.darkIndigo, for: .selected)
        rightButton.setImage(nil, for: .normal)
        rightButton.backgroundColor = .clear
        rightButton.addTarget(self, action: #selector(rightButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.addSubview(rightButton)

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.leftAnchor.constraint(equalTo: leftButton.rightAnchor, constant: 18.0).isActive = true
        rightButton.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true

        self.rightButton = rightButton
    }

    func configure(with data: WalletDetailsSwitcherViewData) {
        switch data.currentChoice {
        case .left:
            leftButton.isSelected = true
            rightButton.isSelected = false
        case .right:
            leftButton.isSelected = false
            rightButton.isSelected = true
        }

        leftButton.setTitle(data.choiceLeft, for: .normal)
        rightButton.setTitle(data.choiceRight, for: .normal)

        leftButton.sizeToFit()
        rightButton.sizeToFit()
    }

    @objc
    private func leftButtonTouchUpInsideEvent(_ sender: SelectableButton) {
        guard !leftButton.isSelected else {
            return
        }

        leftButton.isSelected = true
        rightButton.isSelected = false

        delegate?.walletDetailsSwitcher(self, buttonSelected: .left)
    }

    @objc
    private func rightButtonTouchUpInsideEvent(_ sender: SelectableButton) {
        guard !rightButton.isSelected else {
            return
        }

        leftButton.isSelected = false
        rightButton.isSelected = true

        delegate?.walletDetailsSwitcher(self, buttonSelected: .right)
    }
}
