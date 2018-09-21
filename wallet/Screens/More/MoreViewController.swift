//
//  MoreViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 14/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class MoreViewController: FlowViewController, WalletNavigable {

    var userManager: UserDefaultsManager?
    var authAPI: AuthAPI?

    var onExit: (() -> Void)?

    @IBOutlet private var changePasswordButton: MenuButton?
    @IBOutlet private var supportButton: MenuButton?
    @IBOutlet private var baseCurrencyButton: MenuButton?

    @IBOutlet private var telegramButton: HighlightableButton?
    @IBOutlet private var socialButtonsStackView: UIStackView?
    @IBOutlet private var versLabel: UILabel?

    @IBOutlet private var backgroundView: UIView?

    @IBOutlet private var socialButtonsStackViewBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            socialButtonsStackViewBottomConstraint?.constant = 20.0
        case .medium, .plus, .extra, .extraLarge:
            socialButtonsStackViewBottomConstraint?.constant = 45.0
        case .unknown:
            fatalError()
        }

        backgroundView?.backgroundColor = .white
        view.applyDefaultGradientHorizontally()

        if let phone = userManager?.getPhoneNumber() {
            navigationItem.title = phone
        }

        let exitItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "logIn"),
            style: .plain,
            target: self,
            action: #selector(exitButtonTouchUpInsideEvent(_:))
        )
        exitItem.tintColor = .white
        navigationItem.rightBarButtonItem = exitItem

        setupSocialButtons()

        supportButton?.addTarget(self, action: #selector(supportButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
        telegramButton?.addTarget(self, action: #selector(telegramButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        setupStyle()
    }

    private func setupStyle() {
        changePasswordButton?.custom.setup(title: "Change password", image: #imageLiteral(resourceName: "edit"))
        supportButton?.custom.setup(title: "Support message", image: #imageLiteral(resourceName: "mail"))
        baseCurrencyButton?.custom.setup(title: "Base currency", image: #imageLiteral(resourceName: "refreshCw"))

        changePasswordButton?.custom.setEnabled(false)
        supportButton?.custom.setEnabled(true)
        baseCurrencyButton?.custom.setEnabled(false)

        telegramButton?.setTitle("Join us on Telegram", for: .normal)
        telegramButton?.setTitleColor(.skyBlue, for: .normal)
        telegramButton?.setTitleColor(UIColor.skyBlue.withAlphaComponent(0.3), for: .highlighted)
        telegramButton?.adjustsImageWhenHighlighted = false
        telegramButton?.setHighlightedTintColor(UIColor.skyBlue.withAlphaComponent(0.3))
        telegramButton?.setImage(#imageLiteral(resourceName: "telegram"), for: .normal)
        telegramButton?.backgroundColor = .clear
        telegramButton?.borderWidth = 2.0
        telegramButton?.borderColor = .skyBlue
        telegramButton?.circleCorner = true
        telegramButton?.contentEdgeInsets = UIEdgeInsets.init(top: 15, left: 26, bottom: 15, right: 15)
        telegramButton?.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 26)

        socialButtonsStackView?.spacing = 26.0
        socialButtonsStackView?.axis = .horizontal
        socialButtonsStackView?.alignment = .center
        socialButtonsStackView?.distribution = .equalSpacing

        versLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        versLabel?.text = "zam.wallet alfa v. 0.0.1"
        versLabel?.textColor = UIColor.black.withAlphaComponent(0.1)
    }

    private func setupSocialButtons() {
        let twitterButton = HighlightableButton(type: .custom)
        twitterButton.contentEdgeInsets = UIEdgeInsets.zero
        twitterButton.setImage(#imageLiteral(resourceName: "twitter"), for: .normal)
        twitterButton.tintColor = UIColor.black.withAlphaComponent(0.1)
        twitterButton.setHighlightedTintColor(.darkIndigo)

        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        twitterButton.widthAnchor.constraint(equalToConstant: 31.0).isActive = true
        twitterButton.addTarget(self, action: #selector(twitterButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        socialButtonsStackView?.addArrangedSubview(twitterButton)

        let mediumButton = HighlightableButton(type: .custom)
        mediumButton.contentEdgeInsets = UIEdgeInsets.zero
        mediumButton.setImage(#imageLiteral(resourceName: "medium"), for: .normal)
        mediumButton.tintColor = UIColor.black.withAlphaComponent(0.1)
        mediumButton.setHighlightedTintColor(.darkIndigo)

        mediumButton.translatesAutoresizingMaskIntoConstraints = false
        mediumButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        mediumButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        mediumButton.addTarget(self, action: #selector(mediumButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        socialButtonsStackView?.addArrangedSubview(mediumButton)

        let facebookButton = HighlightableButton(type: .custom)
        facebookButton.contentEdgeInsets = UIEdgeInsets.zero
        facebookButton.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        facebookButton.tintColor = UIColor.black.withAlphaComponent(0.1)
        facebookButton.setHighlightedTintColor(.darkIndigo)

        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        facebookButton.addTarget(self, action: #selector(facebookButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        socialButtonsStackView?.addArrangedSubview(facebookButton)
    }

    @objc
    private func supportButtonTouchUpInsideEvent(_ sender: UIButton) {
        UIApplication.shared.open(ExternalLinks.message.url)
    }

    @objc
    private func telegramButtonTouchUpInsideEvent(_ sender: UIButton) {
        UIApplication.shared.open(ExternalLinks.telegram.url)
    }

    @objc
    private func twitterButtonTouchUpInsideEvent(_ sender: UIButton) {
        UIApplication.shared.open(ExternalLinks.twitter.url)
    }

    @objc
    private func mediumButtonTouchUpInsideEvent(_ sender: UIButton) {
        UIApplication.shared.open(ExternalLinks.medium.url)
    }

    @objc
    private func facebookButtonTouchUpInsideEvent(_ sender: UIButton) {
        UIApplication.shared.open(ExternalLinks.facebook.url)
    }

    @objc
    private func exitButtonTouchUpInsideEvent(_ sender: Any) {
        let exit: () -> Void = {
            [weak self] in

            do {
                try self?.userManager?.clearUserData()
            } catch let error {
                fatalError("Error on clearing user data: \(error)")
            }

            self?.onExit?()
        }

        guard let token = userManager?.getToken() else {
            exit()
            return
        }

        authAPI?.signOut(token: token).done {
            exit()
        }.catch {
            error in
            exit()
        }
    }
}
