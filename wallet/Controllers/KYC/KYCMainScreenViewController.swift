//
//  KYCMainScreenViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class KYCMainScreenViewController: FlowViewController, WalletNavigable {

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    var onKyc0: ((KYCPersonalInfo?) -> Void)?
    var onKyc1: (() -> Void)?

    @IBOutlet private var backgroundView: UIView?

    @IBOutlet private var topPlaceholderComponent: IllustrationalPlaceholder?
    @IBOutlet private var kyc0Button: StageButton?
    @IBOutlet private var kyc1Button: StageButton?
    @IBOutlet private var bottomPlaceholderLabel: UILabel?

    // MARK: - Constraints

    @IBOutlet private var topPlaceholderHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var topPlaceholderBottomConstraint: NSLayoutConstraint?
    @IBOutlet private var bottomPlaceholderTopConstraint: NSLayoutConstraint?

    // MARK: - Private properties

    private var personalInfoData: KYCPersonalInfo?
    private var kyc0ApprovingState: KYCStatus = .unloaded

    // MARK: - UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let token = userManager?.getToken() else {
            return
        }

        guard let kyc0Button = kyc0Button else {
            return
        }

        kyc0Button.custom.beginLoading()
        kyc0Button.isUserInteractionEnabled = false

        userAPI?.getKYCPersonalInfo(token: token).done {
            [weak self]
            personalInfo in

            kyc0Button.custom.endLoading()
            kyc0Button.isUserInteractionEnabled = true

            self?.personalInfoData = personalInfo
            self?.kyc0ApprovingState = personalInfo.status

            switch personalInfo.status {
            case .unloaded:
                kyc0Button.custom.changeState(to: 0)
            case .pending:
                kyc0Button.custom.changeState(to: 1)
            case .verified:
                kyc0Button.custom.changeState(to: 2)
            }
        }.catch {
            error in

            Crashlytics.sharedInstance().recordError(error)
        }

        kyc1Button?.custom.setEnabled(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var buttonsType: StageButtonType

        switch UIScreen.main.type {
        case .small, .extraSmall:
            topPlaceholderComponent?.font = UIFont.walletFont(ofSize: 12.0, weight: .medium)
            topPlaceholderComponent?.prepare(preset: .superCompact)
            topPlaceholderHeightConstraint?.constant = 150.0
            topPlaceholderBottomConstraint?.constant = -5.0
            bottomPlaceholderTopConstraint?.constant = 12.0

            buttonsType = .medium
        case .medium:
            topPlaceholderComponent?.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
            topPlaceholderComponent?.prepare(preset: .compact)
            topPlaceholderHeightConstraint?.constant = 250.0
            topPlaceholderBottomConstraint?.constant = 5.0
            bottomPlaceholderTopConstraint?.constant = 17.0

            buttonsType = .large
        case .extra, .extraLarge, .plus:
            topPlaceholderComponent?.font = UIFont.walletFont(ofSize: 14.0, weight: .medium)
            topPlaceholderComponent?.prepare(preset: .default)
            topPlaceholderHeightConstraint?.constant = 250.0
            topPlaceholderBottomConstraint?.constant = 20.0
            bottomPlaceholderTopConstraint?.constant = 22.0

            buttonsType = .large
        case .unknown:
            fatalError()
        }

        backgroundView?.backgroundColor = .white
        view.applyDefaultGradientHorizontally()

        topPlaceholderComponent?.text = "Pass the procedure of identification to the end and get bonus 500 ZAM-tokens"
        topPlaceholderComponent?.textColor = .black
        topPlaceholderComponent?.image = #imageLiteral(resourceName: "kyc")

        let kyc0Stages = [
            StageDescription(id: "KYC0", idTextColor: .azure, description: "Personal info and address", descriptionTextColor: .darkIndigo, backgroundColor: .white, image: #imageLiteral(resourceName: "chevronRight"), imageTintColor: .darkIndigo),
            StageDescription(id: "KYC0", idTextColor: nil, description: "Personal info and address", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(id: "KYC0", idTextColor: nil, description: "Personal info and address", descriptionTextColor: .white, backgroundColor: .paleOliveGreen, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)]
        
        kyc0Button?.custom.setup(type: buttonsType, stages: kyc0Stages)
        kyc0Button?.addTarget(self, action: #selector(kyc0ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        let kyc1Stages = [
            StageDescription(id: "KYC1", idTextColor: .azure, description: "Photos of documents", descriptionTextColor: .darkIndigo, backgroundColor: .white, image: #imageLiteral(resourceName: "chevronRight"), imageTintColor: .darkIndigo),
            StageDescription(id: "KYC1", idTextColor: nil, description: "Photos of documents", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(id: "KYC1", idTextColor: nil, description: "Photos of documents", descriptionTextColor: .white, backgroundColor: .paleOliveGreen, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)]
        kyc1Button?.custom.setup(type: buttonsType, stages: kyc1Stages)
        kyc1Button?.addTarget(self, action: #selector(kyc1ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        bottomPlaceholderLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        bottomPlaceholderLabel?.textColor = UIColor.black.withAlphaComponent(0.2)
        bottomPlaceholderLabel?.textAlignment = .left
        bottomPlaceholderLabel?.numberOfLines = 0
        bottomPlaceholderLabel?.text = "Upload photos of your passport, ID card, or driving license as your ID document. \n\nIf you submit your passport photos, make sure it’s a reversal image. If you submit ID card or driving license, please upload 2 photos of both sides those documents. Scans and screenshots are not accepted."
    }

    // MARK: - Public methods

    func updateKYC0State(_ state: KYCStatus) {
        self.kyc0ApprovingState = state

        switch state {
        case .unloaded:
            kyc0Button?.custom.changeState(to: 0)
        case .pending:
            kyc0Button?.custom.changeState(to: 1)
        case .verified:
            kyc0Button?.custom.changeState(to: 2)
        }
    }

    // MARK: - Private methods

    @objc
    private func kyc0ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onKyc0?(personalInfoData)
    }

    @objc
    private func kyc1ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onKyc1?()
    }
}
