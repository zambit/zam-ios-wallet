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

    var onClose: ((_ owner: WalletViewController) -> Void)?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var amountLabel: UILabel?
    @IBOutlet private var amountDetailLabel: UILabel?
    @IBOutlet private var recipientDataLabel: UILabel?
    @IBOutlet private var sendButton: LargeSendButton?
    @IBOutlet private var errorMessageLabel: UILabel?

    @IBOutlet private var closeButton: UIButton?

    private var effectView: UIVisualEffectView?
    private var backgroundView: UIView?

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

            self?.titleLabel?.alpha = 1.0
            self?.amountLabel?.alpha = 1.0
            self?.amountDetailLabel?.alpha = 1.0
            self?.recipientDataLabel?.alpha = 1.0
            self?.sendButton?.alpha = 1.0

        }, completion: {
            [weak self]
            _ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.walletNavigationController?.addBackButton(for: strongSelf, target: strongSelf, action: #selector(strongSelf.closeButtonTouchUpInsideEvent(_:)))
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

        errorMessageLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        errorMessageLabel?.textAlignment = .center
        errorMessageLabel?.textColor = .error

        closeButton?.setTitle("Close", for: .normal)
        closeButton?.setTitleColor(.white, for: .normal)
        closeButton?.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        closeButton?.addTarget(self, action: #selector(closeButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

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

            errorMessageLabel?.text = ""
            errorMessageLabel?.sizeToFit()
            closeButton?.isHidden = true

        case .failure:
            let attributedString = NSMutableAttributedString(string: "Transaction canceled", attributes: [
                .font: UIFont.walletFont(ofSize: 40.0, weight: .bold),
                .foregroundColor: UIColor.white,
                .kern: 0.0
                ])
            attributedString.addAttribute(.foregroundColor, value: UIColor.pigPink, range: NSRange(location: 12, length: 8))

            titleLabel?.attributedText = attributedString

            //errorMessageLabel?.sizeToFit()
            closeButton?.isHidden = false

            walletNavigationController?.hideBackButton(for: self)
        case .success:
            let attributedString = NSMutableAttributedString(string: "Transaction completed", attributes: [
                .font: UIFont.walletFont(ofSize: 40.0, weight: .bold),
                .foregroundColor: UIColor.white,
                .kern: 0.0
                ])
            attributedString.addAttribute(.foregroundColor, value: UIColor.paleOliveGreen, range: NSRange(location: 12, length: 9))

            titleLabel?.attributedText = attributedString
            
            amountLabel?.text?.addPrefixIfNeeded("-")

            errorMessageLabel?.text = ""
            errorMessageLabel?.sizeToFit()
            closeButton?.isHidden = false

            walletNavigationController?.hideBackButton(for: self)
        }
    }

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: LargeSendButton) {
        switch sender.sendState {
        case .initial:
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
                    self?.changeDataFor(state: .success)
                }
                }.catch {
                    [weak self]
                    error in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.sendButton?.customAppearance.setFailure()
                        self?.changeDataFor(state: .failure)

                        if let serverError = error as? WalletResponseError {
                            switch serverError {
                            case .serverFailureResponse(errors: let fails):
                                guard let fail = fails.first else {
                                    fatalError()
                                }

                                self?.errorMessageLabel?.text = fail.message.capitalizingFirst
                            case .undefinedServerFailureResponse:

                                self?.errorMessageLabel?.text = "Undefined error"
                            }
                        }
                    }
            }
        case .loading, .success:
            break
        case .failure:
            closeButtonTouchUpInsideEvent(sender)
        }
    }

    @objc
    private func closeButtonTouchUpInsideEvent(_ sender: UIButton) {
        UIView.animate(withDuration: 0.8, animations: {
            [weak self] in

            self?.titleLabel?.alpha = 0.0
            self?.amountLabel?.alpha = 0.0
            self?.amountDetailLabel?.alpha = 0.0
            self?.recipientDataLabel?.alpha = 0.0
            self?.sendButton?.alpha = 0.0
            self?.errorMessageLabel?.alpha = 0.0
            self?.closeButton?.alpha = 0.0

            self?.effectView?.alpha = 0.0
            self?.backgroundView?.alpha = 0.0
        }, completion: {
            [weak self]
            _ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.onClose?(strongSelf)
        })
    }

    private func overlayBlurredBackgroundView() {
        effectView = UIVisualEffectView()
        effectView?.frame = view.frame

        backgroundView = UIView()
        backgroundView?.frame = view.frame
        backgroundView?.alpha = 0.0
        backgroundView?.backgroundColor = UIColor.cornflower.withAlphaComponent(0.5)

        guard let effectView = effectView, let background = backgroundView else {
            fatalError()
        }

        view.addSubview(background)
        view.sendSubview(toBack: background)

        view.insertSubview(effectView, aboveSubview: background)

        UIView.animate(withDuration: 0.8) {
            background.alpha = 1.0
            effectView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        }
    }
}
