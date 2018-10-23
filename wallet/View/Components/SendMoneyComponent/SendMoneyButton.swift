//
//  SendMoneyButton.swift
//  wallet
//
//  Created by  me on 15/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyButton: UIButton {

    enum EditingState {
        case disabled
        case editing
        case clear
    }

    fileprivate(set) var editingState: EditingState = .disabled

    fileprivate var mainLabel: UILabel?
    fileprivate var detailLabel: UILabel?

    fileprivate var mainLabelVerticalConstraint: NSLayoutConstraint?
    fileprivate var detailLabelVerticalConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setupSubviews()
        custom.setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setupSubviews()
        custom.setupStyle()
    }
}

extension BehaviorExtension where Base: SendMoneyButton {

    var isEnabled: Bool {
        get {
            return base.editingState != .disabled
        }

        set {
            if newValue {
                changeState(to: .clear)
            } else {
                changeState(to: .disabled)
            }
        }
    }

    fileprivate func setupStyle() {
        base.applyGradient(colors: [.azure, .turquoiseBlueTwo])

        base.setImage(nil, for: .normal)
        base.setTitle(nil, for: .normal)
    }

    fileprivate func setupSubviews() {
        let mainLabel = UILabel()
        mainLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.alpha = 0.5
        mainLabel.text = "SEND"

        base.addSubview(mainLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 15.0).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -15.0).isActive = true
        base.mainLabelVerticalConstraint = mainLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor)
        base.mainLabelVerticalConstraint?.isActive = true

        base.mainLabel = mainLabel


        let detailLabel = UILabel()
        detailLabel.font = UIFont.walletFont(ofSize: 10, weight: .medium)
        detailLabel.textAlignment = .center
        detailLabel.textColor = .white
        detailLabel.alpha = 0.0

        base.addSubview(detailLabel)

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 15.0).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -15.0).isActive = true
        base.detailLabelVerticalConstraint = detailLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor)
        base.detailLabelVerticalConstraint?.isActive = true

        base.detailLabelVerticalConstraint?.constant = base.bounds.height / 5

        base.detailLabel = detailLabel
    }

    func provide(amount: String, alternative: String) {
        changeState(to: .editing)

        base.mainLabel?.text = "SEND \(amount)"
        base.detailLabel?.text = alternative

        base.resignFirstResponder()
        base.layoutIfNeeded()
    }

    fileprivate func changeState(to state: Base.EditingState) {
        base.editingState = state

        UIView.animate(withDuration: 0.15) {
            switch state {
            case .editing:
                self.base.mainLabelVerticalConstraint?.constant = -9
                self.base.detailLabelVerticalConstraint?.constant = 9

                self.base.mainLabel?.alpha = 1.0
                self.base.detailLabel?.alpha = 1.0
            case .clear:
                self.base.mainLabelVerticalConstraint?.constant = 0
                self.base.detailLabelVerticalConstraint?.constant = 0

                self.base.mainLabel?.alpha = 1.0
                self.base.detailLabel?.alpha = 0.0

                self.base.mainLabel?.text = "SEND"
            case .disabled:
                self.base.mainLabelVerticalConstraint?.constant = 0
                self.base.detailLabelVerticalConstraint?.constant = 0

                self.base.mainLabel?.alpha = 0.5
                self.base.detailLabel?.alpha = 0.0

                self.base.mainLabel?.text = "SEND"
            }

            self.base.layoutIfNeeded()
        }
    }
}
