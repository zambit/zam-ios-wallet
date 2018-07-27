//
//  ExampleOnboardingItem.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

/**
 Page of the tutorial on Onboarding screen. This skeleton defined only by sample design. Image + Title + Text.
 */
class ExampleOnboardingItem: UICollectionViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var illustrationImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var textLabel: UILabel?

    var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            view.frame = CGRect(x: insets.left,
                                y: insets.top,
                                width: bounds.width - insets.left - insets.right,
                                height: bounds.height - insets.top - insets.bottom)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromNib()
        setupStyle()
    }

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

    private func initFromNib() {
        Bundle.main.loadNibNamed("ExampleOnboardingItem", owner: self, options: nil)
        addSubview(view)

        view.frame = CGRect(x: insets.left,
                            y: insets.top,
                            width: bounds.width - insets.left - insets.right,
                            height: bounds.height - insets.top - insets.bottom)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear

        titleLabel?.textColor = .white
        textLabel?.textColor = .silver
    }
}
