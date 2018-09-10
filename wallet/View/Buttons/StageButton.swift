//
//  StageButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

enum StageButtonType {
    case large
    case medium
    case small
}

struct StageDescription {
    let id: String?
    let idTextColor: UIColor?

    let description: String
    let descriptionTextColor: UIColor

    let backgroundColor: UIColor
}

class StageButton: UIButton {

    var type: StageButtonType?

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

    func setup(type: StageButtonType, stages: [StageDescription]) {
        base.type = type
        setupStages(stages)
    }

    func changeState(to index: Int, indicatorBlock: (UIImageView) -> Void) {
        base.currentStateIndex = index

        if let imageView = base.indicatorImageView {
            indicatorBlock(imageView)
        }
    }

    func setupStages(_ stages: [StageDescription]) {
        base.stages = stages

        if let type = base.type {
            setupSubviews(type: type)
        }
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
        if let type = base.type {
            switch type {
            case .large, .medium:
                base.layer.cornerRadius = 12
            case .small:
                base.layer.cornerRadius = base.bounds.height / 2
            }
        }
    }

    func setupSubviews(type: StageButtonType) {
        base.viewWithTag(9419)?.removeFromSuperview()
        base.viewWithTag(4519319)?.removeFromSuperview()
        base.viewWithTag(9144919)?.removeFromSuperview()

        switch type {
        case .large, .medium:
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
            idLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

            base.idLabel = idLabel

            let describingLabel = UILabel()
            if type == .medium {
                describingLabel.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
                describingLabel.numberOfLines = 0
            } else {
                describingLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
            }
            describingLabel.tag = 4519319

            base.addSubview(describingLabel)

            describingLabel.translatesAutoresizingMaskIntoConstraints = false
            describingLabel.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: 24.0).isActive = true
            describingLabel.topAnchor.constraint(greaterThanOrEqualTo: base.topAnchor, constant: 4.0).isActive = true
            describingLabel.bottomAnchor.constraint(lessThanOrEqualTo: base.bottomAnchor, constant: 4.0).isActive = true
            describingLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
            describingLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            base.describingLabel = describingLabel


            let indicatorImageView = UIImageView()
            indicatorImageView.tag = 9144919

            base.addSubview(indicatorImageView)

            indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
            indicatorImageView.leftAnchor.constraint(equalTo: describingLabel.rightAnchor, constant: 18.0).isActive = true
            indicatorImageView.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -16.0).isActive = true
            indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor).isActive = true
            indicatorImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            indicatorImageView.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true

            base.indicatorImageView = indicatorImageView

        case .small:

            let describingLabel = UILabel()
            describingLabel.font = UIFont.walletFont(ofSize: 16.0, weight: .bold)
            describingLabel.textAlignment = .center
            describingLabel.numberOfLines = 1
            describingLabel.tag = 4519319

            base.addSubview(describingLabel)

            describingLabel.translatesAutoresizingMaskIntoConstraints = false
            describingLabel.topAnchor.constraint(greaterThanOrEqualTo: base.topAnchor, constant: 4.0).isActive = true
            describingLabel.bottomAnchor.constraint(lessThanOrEqualTo: base.bottomAnchor, constant: 4.0).isActive = true
            describingLabel.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
            describingLabel.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true

            base.describingLabel = describingLabel

            let indicatorImageView = UIImageView()
            indicatorImageView.tag = 9144919

            base.addSubview(indicatorImageView)

            indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
            indicatorImageView.leftAnchor.constraint(equalTo: describingLabel.rightAnchor, constant: 8.0).isActive = true
            indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor).isActive = true
            indicatorImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            indicatorImageView.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true

            base.indicatorImageView = indicatorImageView
        }

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

    func setEnabled(_ enabled: Bool) {
        base.isUserInteractionEnabled = enabled
        base.alpha = enabled ? 1.0 : 0.3
    }
}
