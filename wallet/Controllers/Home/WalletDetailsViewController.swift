//
//  WalletDetailsViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletDetailsViewController: FlowViewController, WalletNavigable, UITableViewDelegate, UITableViewDataSource {

    var onExit: (() -> Void)?

    @IBOutlet private var tableView: UITableView?
    private var exitButton: HighlightableButton?

    private var phone: String?
    private var wallets: [WalletData]?
    private var currentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.isEnabled = true

        self.view.backgroundColor = .clear
        self.view.isOpaque = false

        self.tableView?.hero.id = "floatingView"
        self.tableView?.backgroundColor = .white
        self.tableView?.cornerRadius = 16.0
        self.tableView?.maskToBounds = true
        self.tableView?.tableFooterView = UIView()

        let exitButton = HighlightableButton(type: .custom)
        exitButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        exitButton.setImage(#imageLiteral(resourceName: "icExit"), for: .normal)
        exitButton.setHighlightedTintColor(.darkIndigo)

        view.addSubview(exitButton)

        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35.0).isActive = true
        exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exitButton.addTarget(self, action: #selector(exitButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        self.exitButton = exitButton
    }

    func prepare(wallets: [WalletData], currentIndex: Int, phone: String) {
        self.phone = phone
        self.wallets = wallets
        self.currentIndex = currentIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //...
        return UITableViewCell()
    }

    @objc
    private func exitButtonTouchUpInsideEvent(_ sender: Any) {
        dismissKeyboard {
            [weak self] in
            self?.onExit?()
        }
    }
}
