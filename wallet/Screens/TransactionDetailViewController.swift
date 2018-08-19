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

    var userAPI: UserAPI?
    var userManager: UserDataManager?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var amountLabel: UILabel?
    @IBOutlet private var amountDetailLabel: UILabel?
    @IBOutlet private var recipientDataLabel: UILabel?
    @IBOutlet private var sendButton: LargeSendButton?

    private var sendMoneyData: SendMoneyData?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        titleLabel?.alpha = 0.0
        amountLabel?.alpha = 0.0
        amountDetailLabel?.alpha = 0.0
        recipientDataLabel?.alpha = 0.0
        sendButton?.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        overlayBlurredBackgroundView()

        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in

            self?.titleLabel?.alpha = 1
            self?.amountLabel?.alpha = 1
            self?.amountDetailLabel?.alpha = 1
            self?.recipientDataLabel?.alpha = 1
            self?.sendButton?.alpha = 1
        })
    }

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
        guard let token = userManager?.getToken() else {
            fatalError()
        }

        guard let data = sendMoneyData else {
            return
        }

        var recipient: String

        switch data.method {
        case .phone(data: let phone):
            recipient = phone
        case .address(data: let address):
            recipient = address
        }

        sendButton?.customAppearance.setLoading()

        userAPI?.sendTransaction(token: token, walletId: data.walletId, recipient: recipient, amount: data.amountData.original).done {
            [weak self]
            transaction in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.sendButton?.customAppearance.setSuccess()
            }
        }.catch {
            [weak self]
            error in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.sendButton?.customAppearance.setFailure()
            }
            print(error)
        }
    }

    private func overlayBlurredBackgroundView() {

        let effectView = UIVisualEffectView()
        effectView.frame = view.frame
        effectView.backgroundColor = UIColor.backgroundLighter.withAlphaComponent(0.4)

        view.addSubview(effectView)
        view.sendSubview(toBack: effectView)

        UIView.animate(withDuration: 0.8) {
            effectView.effect = UIBlurEffect(style: .dark)
        }
    }
}
