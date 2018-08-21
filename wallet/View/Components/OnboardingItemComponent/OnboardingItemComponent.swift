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
class OnboardingItemComponent: ItemComponent {

    @IBOutlet var illustrationImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var textLabel: UILabel?

    @IBOutlet private var topImageToSafeAreaConstraint: NSLayoutConstraint?
    @IBOutlet private var bottomImageToTopTitleConstraint: NSLayoutConstraint?
    @IBOutlet private var leftImageToSafeAreaTitleConstraint: NSLayoutConstraint?
    @IBOutlet private var rightImageToSafeAreaTitleConstraint: NSLayoutConstraint?

    func configure(data: OnboardingItemData) {
        illustrationImageView?.image = data.image
        titleLabel?.text = data.title
        textLabel?.text = data.text
    }

    func configure(image: UIImage, title: String, text: String) {
        illustrationImageView?.image = image
        titleLabel?.text = title
        textLabel?.text = text
    }

    override func initFromNib() {
        super.initFromNib()
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.textColor = .white
        textLabel?.textColor = .silver

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            topImageToSafeAreaConstraint?.constant = 20.0
            titleLabel?.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        case .medium:
            topImageToSafeAreaConstraint?.constant = 20.0
            titleLabel?.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
        case .extra, .plus:
            topImageToSafeAreaConstraint?.constant = 79.5
            titleLabel?.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
        case .unknown:
            print("Error: Unknown screen")
            break
        }
    }

    private func setupLayouts() {

    }
}
