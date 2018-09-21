//
//  TransactionDetailViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol TransactionDetailViewControllerDelegate: class {

    func transactionDetailViewControllerSendingSucceed(_ transactionDetailViewController: TransactionDetailViewController)
}

class TransactionDetailViewController: FlowViewController, WalletNavigable {

    enum State {
        case confirm
        case success
        case failure
    }

    weak var delegate: TransactionDetailViewControllerDelegate?

    var userAPI: UserAPI?
    var userManager: UserDefaultsManager?

    var onClose: ((_ owner: WalletNavigable) -> Void)?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var amountLabel: UILabel?
    @IBOutlet private var amountDetailLabel: UILabel?
    @IBOutlet private var recipientPhoneLabel: UILabel?
    @IBOutlet private var recipientNameLabel: UILabel?
    @IBOutlet private var sendButton: LargeSendButton?
    @IBOutlet private var errorMessageLabel: UILabel?

    @IBOutlet private var closeButton: UIButton?

    @IBOutlet private var topTitleConstraint: NSLayoutConstraint?
    @IBOutlet private var titleAmountBetweenConstraint: NSLayoutConstraint?
    @IBOutlet private var recipientButtonBetweenConstraint: NSLayoutConstraint?
    @IBOutlet private var titleLeftConstraint: NSLayoutConstraint?
    @IBOutlet private var titleRightConstraint: NSLayoutConstraint?

    private var effectView: UIVisualEffectView?
    private var backgroundView: UIView?

    private var sendingData: SendingData?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        titleLabel?.alpha = 0.0
        amountLabel?.alpha = 0.0
        amountDetailLabel?.alpha = 0.0
        recipientPhoneLabel?.alpha = 0.0
        recipientNameLabel?.alpha = 0.0
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
            self?.recipientPhoneLabel?.alpha = 1.0
            self?.recipientNameLabel?.alpha = 1.0
            self?.sendButton?.alpha = 1.0

        }, completion: {
            [weak self]
            _ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.migratingNavigationController?.custom.addBackButton(for: strongSelf, target: strongSelf, action: #selector(strongSelf.closeButtonTouchUpInsideEvent(_:)))
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.current.screenType {
        case .small, .extraSmall:
            topTitleConstraint?.constant = 0.0
            titleAmountBetweenConstraint?.constant = 47.0
            recipientButtonBetweenConstraint?.constant = 20.0
            titleLeftConstraint?.constant = 17.0
            titleRightConstraint?.constant = 17.0
        case .medium:
            topTitleConstraint?.constant = 7.0
            titleAmountBetweenConstraint?.constant = 67.0
            recipientButtonBetweenConstraint?.constant = 26.0
            titleLeftConstraint?.constant = 35.0
            titleRightConstraint?.constant = 35.0
        case .plus:
            titleAmountBetweenConstraint?.constant = 97.0
            recipientButtonBetweenConstraint?.constant = 46.0
            titleLeftConstraint?.constant = 55.0
            titleRightConstraint?.constant = 55.0
        case .extra:
            topTitleConstraint?.constant = 44.0
            titleAmountBetweenConstraint?.constant = 107.0
            recipientButtonBetweenConstraint?.constant = 56.0
            titleLeftConstraint?.constant = 55.0
            titleRightConstraint?.constant = 55.0
        case .unknown:
            fatalError()
        }

        titleLabel?.font = UIFont.walletFont(ofSize: 40.0, weight: .bold)
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .white

        amountLabel?.font = UIFont.walletFont(ofSize: 46.0, weight: .regular)
        amountLabel?.textAlignment = .center
        amountLabel?.textColor = .white

        amountDetailLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        amountDetailLabel?.textAlignment = .center
        amountDetailLabel?.textColor = .white

        recipientPhoneLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .medium)
        recipientPhoneLabel?.textAlignment = .center
        recipientPhoneLabel?.textColor = .blueGrey

        recipientNameLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        recipientNameLabel?.textAlignment = .center
        recipientNameLabel?.textColor = .blueGrey
        recipientNameLabel?.text = ""

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

    func prepare(sendingData: SendingData) {
        self.sendingData = sendingData

        dataWasLoaded()
    }

    private func dataWasLoaded() {
        guard let data = sendingData else {
            return
        }

        amountLabel?.text = data.amountData.formatted(currency: .original)
        amountDetailLabel?.text = data.amountData.coin.short.uppercased()

        switch data.recipient {
        case .phone(let phone):
            recipientPhoneLabel?.text = phone
        case let .contact(name: name, phone: phone):
            recipientPhoneLabel?.text = phone
            recipientNameLabel?.text = name
        case .address(let address):
            recipientPhoneLabel?.text = address
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

            migratingNavigationController?.custom.hideBackButton(for: self)
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

            migratingNavigationController?.custom.hideBackButton(for: self)
        }
    }

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: LargeSendButton) {
        switch sender.sendState {
        case .initial:
            guard let token = userManager?.getToken() else {
                return
            }

            guard let data = sendingData else {
                return
            }

            var recipient: String

            switch data.recipient {
            case .phone(let phone):
                recipient = phone
            case let .contact(name: _, phone: phone):
                recipient = phone
            case .address(let address):
                recipient = address
            }

            sendButton?.custom.setLoading()

            userAPI?.sendTransaction(token: token, walletId: data.walletId, recipient: recipient, amount: data.amountData.original).done {
                [weak self]
                transaction in

                guard let strongSelf = self else {
                    return
                }

                self?.delegate?.transactionDetailViewControllerSendingSucceed(strongSelf)

                performWithDelay {
                    self?.sendButton?.custom.setSuccess()
                    self?.changeDataFor(state: .success)
                }
            }.catch {
                [weak self]
                error in

                performWithDelay {
                    self?.sendButton?.custom.setFailure()
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
        case .loading:
            break
        case .failure, .success:
            closeButtonTouchUpInsideEvent(sender)
        }
    }

    @objc
    private func closeButtonTouchUpInsideEvent(_ sender: UIButton) {
        migratingNavigationController?.custom.hideBackButton(for: self)

        UIView.animate(withDuration: 0.8, animations: {
            [weak self] in

            self?.titleLabel?.alpha = 0.0
            self?.amountLabel?.alpha = 0.0
            self?.amountDetailLabel?.alpha = 0.0
            self?.recipientPhoneLabel?.alpha = 0.0
            self?.recipientNameLabel?.alpha = 0.0
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
