//
//  OnboardingItemComponent.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

/**
 Page of the tutorial on Onboarding screen. This skeleton defined only by sample design. Image + Title + Text.
 */
class OnboardingItemComponent: ItemComponent, SizePresetable {

    @IBOutlet var illustrationImageView: UIImageView?
    @IBOutlet var textLabel: UILabel?

    @IBOutlet private var illustrationImageViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private var illustrationImageViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet private var illustrationImageViewHeightConstraint: NSLayoutConstraint?

    private var textAttributes: [NSAttributedStringKey: Any] = [:]
    private var additionalTextAttributes: [NSAttributedStringKey: Any] = [:]

    func configure(data: OnboardingItemData) {
        self.configure(image: data.image, text: data.text, additional: data.additionalText)
    }

    func configure(image: UIImage, text: String, additional: String?) {
        illustrationImageView?.image = image

        let mutableText = NSMutableAttributedString(string: text, attributes: textAttributes)

        if let additional = additional {
            let additionalText = NSAttributedString(string: "\n\(additional)", attributes: additionalTextAttributes)
            mutableText.append(additionalText)
        }

        textLabel?.attributedText = mutableText
    }

    func prepare(preset: SizePreset) {
        switch preset {
        case .superCompact:
            illustrationImageViewTopConstraint?.constant = 20
            illustrationImageViewBottomConstraint?.constant = 0
            illustrationImageViewHeightConstraint?.constant = 200
        case .compact:
            illustrationImageViewTopConstraint?.constant = 40
            illustrationImageViewBottomConstraint?.constant = 0
            illustrationImageViewHeightConstraint?.constant = 200
        case .default:
            illustrationImageViewTopConstraint?.constant = 79
            illustrationImageViewBottomConstraint?.constant = 0
            illustrationImageViewHeightConstraint?.constant = 230
        }
    }

    override func initFromNib() {
        super.initFromNib()
    }

    override func setupStyle() {
        super.setupStyle()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center

        let font = UIFont.walletFont(ofSize: 18, weight: .medium)
        let textColor = UIColor.fadedBlue

        textAttributes = [.paragraphStyle: paragraphStyle, .font: font, .foregroundColor: textColor]

        let additionalFont = UIFont.walletFont(ofSize: 18, weight: .regular)
        let additionalTextColor = UIColor.fadedBlue

        additionalTextAttributes = [.paragraphStyle: paragraphStyle, .font: additionalFont, .foregroundColor: additionalTextColor]

        textLabel?.numberOfLines = 0
        illustrationImageView?.contentMode = .scaleAspectFill

//        switch UIDevice.current.screenType {
//        case .extraSmall, .small:
//            topImageToSafeAreaConstraint?.constant = 20.0
//            titleLabel?.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
//        case .medium:
//            topImageToSafeAreaConstraint?.constant = 20.0
//            titleLabel?.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
//        case .extra, .plus:
//            topImageToSafeAreaConstraint?.constant = 79.5
//            titleLabel?.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
//        case .unknown:
//            print("Error: Unknown screen")
//            break
//        }
    }
}
