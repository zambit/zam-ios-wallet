//
//  TransactionDetailViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionDetailViewController: WalletViewController {

    enum State {
        case confirm
        case success
        case failure
    }

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var amountLabel: UILabel?
    @IBOutlet private var amountDetailLabel: UILabel?
    @IBOutlet private var recipientDataLabel: UILabel?
    @IBOutlet private var sendButton: LargeSendButton?

    private var sendMoneyData: SendMoneyData?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel?.font = UIFont.walletFont(ofSize: 40.0, weight: .bold)
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .white

        amountLabel?.font = UIFont.walletFont(ofSize: 46.0, weight: .regular)
        amountLabel?.textAlignment = .center
        amountLabel?.textColor = .white

        amountDetailLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        amountDetailLabel?.textAlignment = .center
        amountDetailLabel?.textColor = .white

        recipientDataLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .medium)
        recipientDataLabel?.textAlignment = .center
        recipientDataLabel?.textColor = .blueGrey

        view.backgroundColor = .clear

        sendButton?.addTarget(self, action: #selector(sendButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
        dataWasLoaded()

        changeDataFor(state: .confirm)
    }

    func prepare(sendMoneyData: SendMoneyData) {
        self.sendMoneyData = sendMoneyData

        dataWasLoaded()
    }

    private func dataWasLoaded() {
        guard let data = sendMoneyData else {
            return
        }

        amountLabel?.text = data.amountData.formatted(currency: .original)
        amountDetailLabel?.text = data.amountData.coin.short.uppercased()

        switch data.method {
        case .phone(data: let phone):
            recipientDataLabel?.text = phone
        case .address(data: let adress):
            recipientDataLabel?.text = adress
        }
    }

    private func changeDataFor(state: State) {
        switch state {
        case .confirm:
            titleLabel?.text = "Confirm transaction"

        case .failure:
            titleLabel?.text = "Transaction completed"

        case .success:
            titleLabel?.text = "Transaction completed"

        }
    }

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: UIButton) {
        sendButton?.customAppearance.setLoading()
    }
}
