//
//  DepositMoneyViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class DepositMoneyViewController: FlowViewController, WalletNavigable, DepositMoneyMethodComponentDelegate {

    var onShare: ((String) -> Void)?

    @IBOutlet private var methodControllerComponent: DepositMoneyMethodComponent?
    @IBOutlet private var addressContentComponent: DepositMoneyAddressComponent?

    @IBOutlet private var contentHeightConstraint: NSLayoutConstraint?

    private var wallets: [WalletData]?
    private var phone: String?
    private var currentIndex: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            contentHeightConstraint?.constant = 284.0
        case .medium:
            contentHeightConstraint?.constant = 384.0
        case .plus:
            contentHeightConstraint?.constant = 454.0
        case .extra:
            contentHeightConstraint?.constant = 474.0
        case .unknown:
            fatalError()
        }

        view.applyDefaultGradientHorizontally()

        methodControllerComponent?.delegate = self
        addressContentComponent?.onShare = onShare

        if let wallets = wallets, let index = currentIndex, let phone = phone {
            methodControllerComponent?.prepare(wallets: wallets, currentIndex: index, phone: phone)
        }
    }

    func prepare(wallets: [WalletData], currentIndex: Int, phone: String) {
        self.wallets = wallets
        self.currentIndex = currentIndex
        self.phone = phone
    }

    func depositMoneyMethodSelected(_ depositMoneyMethodSelected: DepositMoneyMethodComponent, method: DepositMoneyMethod) {

        guard let wallets = wallets, let index = currentIndex else {
            return
        }

        switch method {
        case .address:
            //..instantiate
            addressContentComponent?.prepare(address: wallets[index].address)
        case .card:
            //..instantiate
            break
        }
    }

    func depositMoneyMethodWalletChanged(_ depositMoneyMethodSelected: DepositMoneyMethodComponent, toIndex: Int, wallets: [WalletData]) {

        addressContentComponent?.prepare(address: wallets[toIndex].address)
    }

    func depositMoneyMethodCardChanged(_ depositMoneyMethodSelected: DepositMoneyMethodComponent, toCardId: String) {

        //..
    }
    
}