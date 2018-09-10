//
//  KYCMainScreenViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCMainScreenViewController: FlowViewController, WalletNavigable {

    var onKyc0: (() -> Void)?
    var onKyc1: (() -> Void)?

    @IBOutlet private var backgroundView: UIView?

    @IBOutlet private var topPlaceholderComponent: IllustrationalPlaceholder?
    @IBOutlet private var kyc0Button: StageButton?
    @IBOutlet private var kyc1Button: StageButton?
    @IBOutlet private var bottomPlaceholderLabel: UILabel?

    private var kyc0ApprovingState: KYCApprovingState = .initial
    private var kyc1ApprovingState: KYCApprovingState = .initial

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //migratingNavigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView?.backgroundColor = .white
        view.applyDefaultGradientHorizontally()

        topPlaceholderComponent?.text = "Pass the procedure of identification to the end and get bonus 500 ZAM-tokens"
        topPlaceholderComponent?.textColor = .black

        let kyc0Stages = [
            StageDescription(id: "KYC0", idTextColor: .azure, description: "Personal info and address", descriptionTextColor: .darkIndigo, backgroundColor: .white),
            StageDescription(id: "KYC0", idTextColor: nil, description: "Personal info and address", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(id: "KYC0", idTextColor: nil, description: "Personal info and address", descriptionTextColor: .white, backgroundColor: .paleOliveGreen)]
        kyc0Button?.custom.setup(type: .large, stages: kyc0Stages)
        kyc0Button?.custom.changeState(to: 0, indicatorBlock: { imageView in
            imageView.image = #imageLiteral(resourceName: "chevronRight")
            imageView.tintColor = .darkIndigo
        })
        kyc0Button?.addTarget(self, action: #selector(kyc0ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        let kyc1Stages = [
            StageDescription(id: "KYC1", idTextColor: .azure, description: "Photos of documents", descriptionTextColor: .darkIndigo, backgroundColor: .white),
            StageDescription(id: "KYC1", idTextColor: nil, description: "Photos of documents", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(id: "KYC1", idTextColor: nil, description: "Photos of documents", descriptionTextColor: .white, backgroundColor: .paleOliveGreen)]
        kyc1Button?.custom.setup(type: .large, stages: kyc1Stages)
        kyc1Button?.custom.changeState(to: 0, indicatorBlock: { imageView in
            imageView.image = #imageLiteral(resourceName: "chevronRight")
            imageView.tintColor = .darkIndigo
        })
        kyc1Button?.addTarget(self, action: #selector(kyc1ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        bottomPlaceholderLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        bottomPlaceholderLabel?.textColor = UIColor.black.withAlphaComponent(0.2)
        bottomPlaceholderLabel?.textAlignment = .left
        bottomPlaceholderLabel?.numberOfLines = 0
        bottomPlaceholderLabel?.text = "Upload photos of your passport, ID card, or driving license as your ID document. \n\nIf you submit your passport photos, make sure it’s a reversal image. If you submit ID card or driving license, please upload 2 photos of both sides those documents. Scans and screenshots are not accepted."
    }

    func prepare() {
        kyc0Button?.custom.changeState(to: 1, indicatorBlock: { imageView in
            imageView.image = #imageLiteral(resourceName: "icTime")
            imageView.tintColor = .white
        })
    }

    func updateKYC0State(_ state: KYCApprovingState) {
        self.kyc0ApprovingState = state

        switch state {
        case .initial:
            kyc0Button?.custom.changeState(to: 0, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "chevronRight")
                imageView.tintColor = .darkIndigo
            })
        case .onVerification:
            kyc0Button?.custom.changeState(to: 1, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icTime")
                imageView.tintColor = .white
            })
        case .verified:
            kyc0Button?.custom.changeState(to: 2, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icCheck")
                imageView.tintColor = .white
            })
        }
    }

    @objc
    private func kyc0ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onKyc0?()
    }

    @objc
    private func kyc1ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onKyc1?()
    }
}
