//
//  StageButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct StageDescription {
    let id: String
    let idTextColor: UIColor?

    let description: String
    let descriptionTextColor: UIColor

    let backgroundColor: UIColor
}

class StageButton: UIButton {

    var idLabel: UILabel?
    var describingLabel: UILabel?
    var indicatorImageView: UIImageView?

    var currentStateIndex: Int = 0 {
        didSet {
            custom.setupCurrentState()
        }
    }

    var stages: [StageDescription] = [] {
        willSet {
            currentStateIndex = 0
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        custom.setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(nil, for: UIControlState())
        custom.setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle(nil, for: UIControlState())
        custom.setupStyle()
    }
}

extension BehaviorExtension where Base: StageButton {

    var stagesCount: Int {
        return base.stages.count
    }

    func changeState(to index: Int, indicatorBlock: (UIImageView) -> Void) {
        base.currentStateIndex = index

        if let imageView = base.indicatorImageView {
            indicatorBlock(imageView)
        }
    }

    func setupStages(_ stages: [StageDescription]) {
        base.stages = stages

        setupSubviews()
    }

    func setupStyle() {
        base.backgroundColor = .white

        base.layer.masksToBounds = false
        base.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        base.layer.shadowOffset = CGSize(width: -2.0, height: 4.0)
        base.layer.shadowRadius = 21.0
        base.layer.shadowOpacity = 0.5
    }

    func setupLayouts() {
        base.layer.cornerRadius = 12.0
    }

    func setupSubviews() {
        base.viewWithTag(9419)?.removeFromSuperview()
        base.viewWithTag(4519319)?.removeFromSuperview()
        base.viewWithTag(9144919)?.removeFromSuperview()

        let idLabel = UILabel()
        idLabel.font = UIFont.walletFont(ofSize: 20, weight: .medium)
        idLabel.tag = 9419

        base.addSubview(idLabel)

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 18.0).isActive = true
        idLabel.topAnchor.constraint(greaterThanOrEqualTo: base.topAnchor, constant: 4.0).isActive = true
        idLabel.bottomAnchor.constraint(lessThanOrEqualTo: base.bottomAnchor, constant: 4.0).isActive = true
        idLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
        idLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        base.idLabel = idLabel

        let describingLabel = UILabel()
        describingLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        describingLabel.tag = 4519319

        base.addSubview(describingLabel)

        describingLabel.translatesAutoresizingMaskIntoConstraints = false
        describingLabel.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: 24.0).isActive = true
        describingLabel.topAnchor.constraint(greaterThanOrEqualTo: base.topAnchor, constant: 4.0).isActive = true
        describingLabel.bottomAnchor.constraint(lessThanOrEqualTo: base.bottomAnchor, constant: 4.0).isActive = true
        describingLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true

        base.describingLabel = describingLabel


        let indicatorImageView = UIImageView()
        indicatorImageView.tag = 9144919

        base.addSubview(indicatorImageView)

        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorImageView.leftAnchor.constraint(equalTo: describingLabel.rightAnchor, constant: 18.0).isActive = true
        indicatorImageView.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -12.0).isActive = true
        indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor).isActive = true
        indicatorImageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        indicatorImageView.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true

        base.indicatorImageView = indicatorImageView

        setupCurrentState()
    }

    func setupCurrentState() {
        let currentIndex = base.currentStateIndex

        guard currentIndex < base.stages.count else {
            return
        }

        let currentStage = base.stages[currentIndex]

        base.describingLabel?.text = currentStage.description
        base.describingLabel?.textColor = currentStage.descriptionTextColor

        base.idLabel?.text = currentStage.id
        base.idLabel?.textColor = currentStage.idTextColor ?? currentStage.descriptionTextColor

        base.backgroundColor = currentStage.backgroundColor
    }
}