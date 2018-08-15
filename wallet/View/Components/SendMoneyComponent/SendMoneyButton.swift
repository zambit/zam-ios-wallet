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

    private var mainLabel: UILabel?
    private var detailLabel: UILabel?

    private var mainLabelVerticalConstraint: NSLayoutConstraint?
    private var detailLabelVerticalConstraint: NSLayoutConstraint?

    struct CustomAppearance {
        weak var parent: SendMoneyButton?

        func setEnabled(_ enabled: Bool) {
            guard let parent = parent, enabled != parent.customEnabled else {
                return
            }

            UIView.animate(withDuration: 0.1, animations: {
                switch enabled {
                case true:
                    self.parent?.mainLabel?.alpha = 1
                    self.parent?.mainLabelVerticalConstraint?.constant = -parent.bounds.height / 10

                    self.parent?.customEnabled = true
                case false:
                    self.parent?.mainLabel?.alpha = 0.5
                    self.parent?.mainLabelVerticalConstraint?.constant = 0

                    self.parent?.detailLabel?.alpha = 0.0

                    self.parent?.customEnabled = false

                    self.parent?.mainLabel?.text = "SEND"
                }

                self.parent?.layoutIfNeeded()
            })

            UIView.animate(withDuration: 0.1, delay: 0.1, animations: {
                switch enabled {
                case true:
                    self.parent?.detailLabel?.alpha = 1.0
                case false:
                    break
                }

                self.parent?.layoutIfNeeded()
            })
        }

        func provideData(amount: String, alternative: String) {
            parent?.mainLabel?.text = "SEND \(amount)"
            parent?.detailLabel?.text = alternative
        }
    }

    private var customEnabled: Bool = false

    var customAppearance: CustomAppearance {
        return CustomAppearance(parent: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        setupStyle()
    }

    private func setupStyle() {
        applyGradient(colors: [.azure, .turquoiseBlueTwo])

        setImage(nil, for: .normal)
        setTitle(nil, for: .normal)
    }

    private func setupSubviews() {
        mainLabel = UILabel()
        mainLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        mainLabel?.textAlignment = .center
        mainLabel?.textColor = .white
        mainLabel?.alpha = 0.5
        mainLabel?.text = "SEND"
        mainLabel?.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainLabel!)

        mainLabel?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainLabelVerticalConstraint = mainLabel?.centerYAnchor.constraint(equalTo: centerYAnchor)
        mainLabelVerticalConstraint?.isActive = true

        detailLabel = UILabel()
        detailLabel?.font = UIFont.walletFont(ofSize: 10, weight: .medium)
        detailLabel?.textAlignment = .center
        detailLabel?.textColor = .white
        detailLabel?.alpha = 0.0
        detailLabel?.translatesAutoresizingMaskIntoConstraints = false

        addSubview(detailLabel!)

        detailLabel?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailLabelVerticalConstraint = detailLabel?.centerYAnchor.constraint(equalTo: centerYAnchor)
        detailLabelVerticalConstraint?.isActive = true

        detailLabelVerticalConstraint?.constant = bounds.height / 5
    }

    private func setupLayouts() {
    }
}
