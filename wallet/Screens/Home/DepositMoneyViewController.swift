//
//  DepositMoneyViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DepositMoneyViewController: FlowViewController, WalletNavigable, SegmentedControlComponentDelegate, WalletsCollectionComponentDelegate {

    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var onShare: ((String) -> Void)?

    @IBOutlet private var backgroundView: UIView!

    @IBOutlet private var fromLabel: UILabel?
    @IBOutlet private var segmentedControlComponent: SegmentedControlComponent?

    @IBOutlet private var walletsCollectionComponent: WalletsCollectionComponent?
    @IBOutlet private var addressContentComponent: WalletAddressComponent?

    @IBOutlet private var contentHeightConstraint: NSLayoutConstraint?

    private var wallets: [WalletData] = []
    private var phone: String?
    private var currentIndex: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.isEnabled = true
        self.backgroundView.hero.id = "floatingView"

        switch UIScreen.main.type {
        case .extraSmall, .small:
            contentHeightConstraint?.constant = 284.0

            segmentedControlComponent?.alignment = .left
            if let label = fromLabel {
                segmentedControlComponent?.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10.0).isActive = true
            }
        case .medium:
            contentHeightConstraint?.constant = 384.0

            segmentedControlComponent?.alignment = .left
            if let label = fromLabel {
                segmentedControlComponent?.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10.0).isActive = true
            }
        case .plus:
            contentHeightConstraint?.constant = 454.0

            segmentedControlComponent?.alignment = .center
            segmentedControlComponent?.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 0.0).isActive = true
        case .extra, .extraLarge:
            contentHeightConstraint?.constant = 474.0

            segmentedControlComponent?.alignment = .center
            segmentedControlComponent?.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 0.0).isActive = true
        case .unknown:
            fatalError()
        }

        view.applyDefaultGradientHorizontally()

        segmentedControlComponent?.segmentsHorizontalMargin = 15.0
        segmentedControlComponent?.segmentsHorizontalSpacing = 5.0

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "linkTo"), title: "Address", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .lightblue)
        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "card"), title: "Card", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .paleOliveGreen).isEnabled = false

        fromLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        fromLabel?.textColor = .darkIndigo
        fromLabel?.text = "From"
        fromLabel?.sizeToFit()

        addressContentComponent?.onShare = onShare

        if let currentIndex = currentIndex, let phone = phone {
            self.prepare(wallets: wallets, currentIndex: currentIndex, phone: phone)
        }

        walletsCollectionComponent?.delegate = self
        segmentedControlComponent?.delegate = self

        migratingNavigationController?.custom.addBackButton(for: self, target: self, action: #selector(backButtonTouchUpInsideEvent(_:)))
    }

    func prepare(wallets: [WalletData], currentIndex: Int, phone: String) {
        self.wallets = wallets
        self.currentIndex = currentIndex
        self.phone = phone

        let itemsData = wallets.map { WalletItemData(data: $0, phoneNumber: phone) }
        walletsCollectionComponent?.custom.prepare(cards: itemsData, current: currentIndex)
    }

    // MARK: - SegmentedControlComponentDelegate

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int) {
        switch index {
        case 0:
            addressContentComponent?.prepare(address: wallets[index].address)
        case 1:
            //...
            break
        default:
            break
        }
    }

    // MARK: - WalletsCollectionComponentDelegate

    func walletsCollectionComponentCurrentIndexChanged(_ walletsCollectionComponent: WalletsCollectionComponent, to index: Int) {
        currentIndex = index

        addressContentComponent?.prepare(address: wallets[index].address)
    }

    @objc
    private func backButtonTouchUpInsideEvent(_ sender: Any) {
        if let index = currentIndex {
            walletsCollectionComponent?.custom.prepareForAnimation()

            advancedTransitionDelegate?.advancedTransitionWillBegin(from: self, params: ["walletIndex": index])
        }

        migratingNavigationController?.popViewController(animated: true)
    }
}
