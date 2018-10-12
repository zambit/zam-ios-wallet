//
//  WalletDetailsViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletDetailsViewController: FlowViewController, WalletNavigable, AdvancedTransitionDelegate, SendMoneyViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, WalletDetailsBriefDelegate {

    var onSendFromWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onExit: (() -> Void)?

    class CellsBalancer {

        unowned var parent: WalletDetailsViewController

        //private var walletDetailsBrief: WalletDetailsBriefTableViewCell?
        //    private var walletDetailsChart: WalletDetailsBriefTableViewCell?
        //    private var walletDetailsLists: WalletDetailsBriefTableViewCell?

        init(parent: WalletDetailsViewController) {
            self.parent = parent
        }

        func registerCellsInTableView(_ tableView: UITableView) {
            tableView.register(WalletDetailsBriefTableViewCell.self, forCellReuseIdentifier: "WalletDetailsBriefTableViewCell")
        }

        func getNumberOfRowsInSection(_ section: Int) -> Int {
            switch section {
            case 0:
                return 1
            default:
                return 0
            }
        }

        func getConfiguredCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell? {
            switch indexPath {
            case IndexPath(row: 0, section: 0):
                let _cell = parent.tableView?.dequeueReusableCell(withIdentifier: "WalletDetailsBriefTableViewCell", for: indexPath)

                guard let cell = _cell as? WalletDetailsBriefTableViewCell else {
                    return nil
                }

                guard
                    let currentIndex = parent.currentIndex,
                    let wallets = parent.wallets,
                    let phone = parent.phone else {
                    return cell
                }

                let cards = wallets.compactMap {
                    return WalletItemData(data: $0, phoneNumber: phone)
                }

                cell.delegate = parent
                cell.configure(price: "$ 6964", currentIndex: currentIndex, wallets: cards)

                return cell
            default:
                return nil
            }
        }

        func getHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat? {
            switch indexPath {
            case IndexPath(row: 0, section: 0):
                return 200.0
            default:
                return nil
            }
        }
    }

    weak var sendDelegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    @IBOutlet private var tableView: UITableView?
    private var exitButton: HighlightableButton?

    private var phone: String?
    private var wallets: [Wallet]?
    private var currentIndex: Int?

    private lazy var balancer = CellsBalancer(parent: self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.isEnabled = true

        self.setupDefaultStyle()
        //self.view.isOpaque = false

        self.tableView?.hero.id = "floatingView"
        self.tableView?.backgroundColor = .white
        self.tableView?.cornerRadius = 16.0
        self.tableView?.maskToBounds = true
        self.tableView?.separatorStyle = .none
        self.tableView?.allowsSelection = false
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()

        balancer.registerCellsInTableView(tableView!)

        let exitButton = HighlightableButton(type: .custom)
        exitButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        exitButton.setImage(#imageLiteral(resourceName: "icExit"), for: .normal)
        exitButton.setHighlightedTintColor(.darkIndigo)

        view.addSubview(exitButton)

        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25.0).isActive = true
        exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exitButton.addTarget(self, action: #selector(exitButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.exitButton = exitButton
    }

    func prepare(wallets: [Wallet], currentIndex: Int, phone: String) {
        self.wallets = wallets
        self.currentIndex = currentIndex
        self.phone = phone
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balancer.getNumberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return balancer.getConfiguredCellForIndexPath(indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return balancer.getHeightForRowAtIndexPath(indexPath) ?? 0.0
    }

    // MARK: - WalletDetailsBriefDelegate

    func walletDetailsBriefSendButtonTapped(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, walletIndex: Int) {
        guard let wallets = wallets, let phone = phone else {
            return
        }

        onSendFromWallet?(walletIndex, wallets, phone)
    }

    func walletDetailsBriefDepositButtonTapped(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, walletIndex: Int) {
        guard let wallets = wallets, let phone = phone else {
            return
        }

        onDepositToWallet?(walletIndex, wallets, phone)
    }

    func walletDetailsBriefCurrentWalletChanged(_ walletDetailsBrief: WalletDetailsBriefTableViewCell, to index: Int) {
        self.currentIndex = index
    }

    // MARK: - AdvancedTransitionDelegate

    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String : Any]) {
        guard let index = params["walletIndex"] as? Int else {
            return
        }

        currentIndex = index
        tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }

    // MARK: - SendMoneyViewControllerDelegate

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        sendDelegate?.sendMoneyViewControllerSendingProceedWithSuccess(sendMoneyViewController)
    }

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController, updated data: Wallet, index: Int) {
        wallets?[index] = data

        tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }

    // MARK: - Buttons events

    @objc
    private func exitButtonTouchUpInsideEvent(_ sender: Any) {
        if let index = currentIndex {
            advancedTransitionDelegate?.advancedTransitionWillBegin(from: self, params: ["walletIndex": index])
        }

        dismissKeyboard {
            [weak self] in
            self?.onExit?()
        }
    }
}
