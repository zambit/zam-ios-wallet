//
//  CreditCardView.swift
//  wallet
//
//  Created by  me on 09/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreditCardViewComponent: UIView {

    private var titleLabel: UILabel?
    private var numberLabel: UILabel?
    private var withdrawButton: UIButton?

    private var iconImageView: UIImageView?

    private var comingSoonLabel: UILabel?

    private(set) var number: String = ""

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()

        setupSubviews()
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadData()

        setupSubviews()
        setupStyle()
    }

    private func setupSubviews() {
//        iconImageView = UIImageView()
//        addSubview(iconImageView!)
//
//        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
//        iconImageView?.leftAnchor.constraint(equalTo: leftAnchor, constant: 60.0).isActive = true
//        iconImageView?.topAnchor.constraint(equalTo: topAnchor, constant: 47.0).isActive = true
//        iconImageView?.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
//        iconImageView?.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
//
//        titleLabel = UILabel(frame: CGRect.zero)
//        addSubview(titleLabel!)
//
//        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel?.leftAnchor.constraint(equalTo: leftAnchor, constant: 28.0).isActive = true
//        titleLabel?.topAnchor.constraint(equalTo: iconImageView!.bottomAnchor, constant: 4.0).isActive = true
//
//        comingSoonLabel = UILabel(frame: CGRect.zero)
//        addSubview(comingSoonLabel!)
//
//        comingSoonLabel?.translatesAutoresizingMaskIntoConstraints = false
//        comingSoonLabel?.centerXAnchor.constraint(equalTo: titleLabel!.centerXAnchor).isActive = true
//        comingSoonLabel?.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 0.0).isActive = true


        titleLabel = UILabel(frame: CGRect.zero)
        addSubview(titleLabel!)

        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        titleLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 16.0).isActive = true

        numberLabel = UILabel(frame: CGRect.zero)
        addSubview(numberLabel!)

        numberLabel?.translatesAutoresizingMaskIntoConstraints = false
        numberLabel?.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        numberLabel?.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 12.0).isActive = true

        withdrawButton = UIButton(type: .custom)
        addSubview(withdrawButton!)

        withdrawButton?.translatesAutoresizingMaskIntoConstraints = false
        withdrawButton?.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0).isActive = true
        withdrawButton?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0).isActive = true
    }

    private func setupStyle() {
//        self.backgroundColor = UIColor.cornflower.withAlphaComponent(0.12)
//
//        titleLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
//        titleLabel?.textColor = UIColor.skyBlue.withAlphaComponent(0.4)
//        titleLabel?.text = "Add bank card"
//
//        iconImageView?.image = #imageLiteral(resourceName: "xCircle")
//        iconImageView?.setImageColor(color: .skyBlue)
//
//        comingSoonLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
//        comingSoonLabel?.textColor = .skyBlue
//        comingSoonLabel?.text = "Coming soon"

        self.backgroundColor = .skyBlue

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.niceBlue.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowRadius = 23.0
        self.layer.shadowOpacity = 0.9

        titleLabel?.font = UIFont.walletFont(ofSize: 18.0, weight: .bold)
        titleLabel?.textColor = .white
        titleLabel?.text = "Bank Card"

        numberLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        numberLabel?.textColor = .white
        numberLabel?.text = number

        withdrawButton?.backgroundColor = .white
        withdrawButton?.contentEdgeInsets = UIEdgeInsets(top: 11.0, left: 21.0, bottom: 11.0, right: 21.0)
        withdrawButton?.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        withdrawButton?.setTitleColor(.darkIndigo, for: .normal)
        withdrawButton?.setTitle("Withdraw", for: .normal)
        withdrawButton?.addTarget(self, action: #selector(withdrawButtonTapEvent(_:)), for: .touchUpInside)
    }

    private func setupLayouts() {
        self.layer.cornerRadius = 16.0


        if let withdraw = withdrawButton {
            self.withdrawButton?.layer.cornerRadius = withdraw.bounds.height / 2
        }
    }

    private func loadData() {
        let num = "5468123412341488"

        let numberParser = MaskParser(symbol: "X", space: " ")

        let start = num.index(num.startIndex, offsetBy: 4)
        let end = num.index(num.startIndex, offsetBy: 11)
        let numberSafe = num.replacingCharacters(in: start...end, with: "••••••••")

        number = numberParser.matchingStrict(text: numberSafe, withMask: "XXXX XXXX XXXX XXXX")
    }

    @objc
    private func withdrawButtonTapEvent(_ sender: Any) {
    }
}
