//
//  KYCUploadDocumentsMenuViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCUploadDocumentsMenuViewController: FlowViewController, WalletNavigable {

    var onFirstDocument: (() -> Void)?
    var onSecondDocument: (() -> Void)?
    var onThirdDocument: (() -> Void)?

    @IBOutlet private var privateDocumentButton: StageButton?
    @IBOutlet private var selfieButton: StageButton?
    @IBOutlet private var addressDocumentButton: StageButton?

    @IBOutlet private var backgroundView: UIView?

    private var privateDocumentApprovingState: KYCApprovingState = .initial
    private var selfieApprovingState: KYCApprovingState = .initial
    private var addressDocumentApprovingState: KYCApprovingState = .initial

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView?.backgroundColor = .white
        view.applyDefaultGradientHorizontally()

        let document01Stages = [
            StageDescription(id: "01", idTextColor: .azure, description: "Photos passport, or ID card, or Driving license", descriptionTextColor: .darkIndigo, backgroundColor: .white),
            StageDescription(id: "01", idTextColor: nil, description: "Photos passport, or ID card, or Driving license", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(id: "01", idTextColor: nil, description: "Photos passport, or ID card, or Driving license", descriptionTextColor: .white, backgroundColor: .paleOliveGreen)]
        privateDocumentButton?.custom.setup(type: .medium, stages: document01Stages)
        privateDocumentButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
            imageView.image = #imageLiteral(resourceName: "chevronRight")
            imageView.tintColor = .darkIndigo
        })
        privateDocumentButton?.addTarget(self, action: #selector(document01ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        let document02Stages = [
            StageDescription(id: "02", idTextColor: .azure, description: "Selfie of a customer holding the above document", descriptionTextColor: .darkIndigo, backgroundColor: .white),
            StageDescription(id: "02", idTextColor: nil, description: "Selfie of a customer holding the above document", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(id: "02", idTextColor: nil, description: "Selfie of a customer holding the above document", descriptionTextColor: .white, backgroundColor: .paleOliveGreen)]
        selfieButton?.custom.setup(type: .medium, stages: document02Stages)
        selfieButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
            imageView.image = #imageLiteral(resourceName: "chevronRight")
            imageView.tintColor = .darkIndigo
        })
        selfieButton?.addTarget(self, action: #selector(document02ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)


        let document03Stages = [
            StageDescription(id: "03", idTextColor: .azure, description: "Upload document confirming address of residence", descriptionTextColor: .darkIndigo, backgroundColor: .white),
            StageDescription(id: "03", idTextColor: nil, description: "Upload document confirming address of residence", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(id: "03", idTextColor: nil, description: "Upload document confirming address of residence", descriptionTextColor: .white, backgroundColor: .paleOliveGreen)]
        addressDocumentButton?.custom.setup(type: .medium, stages: document03Stages)
        addressDocumentButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
            imageView.image = #imageLiteral(resourceName: "chevronRight")
            imageView.tintColor = .darkIndigo
        })
        addressDocumentButton?.addTarget(self, action: #selector(document03ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func prepare(privateDocumentApprovingState: KYCApprovingState, selfieApprovingState: KYCApprovingState, addressDocumentApprovingState: KYCApprovingState) {
        self.updatePrivateDocumentApprovingState(privateDocumentApprovingState)
        self.updateSelfieApprovingState(selfieApprovingState)
        self.updateAddressDocumentApprovingState(addressDocumentApprovingState)
    }

    func updatePrivateDocumentApprovingState(_ state: KYCApprovingState) {
        self.privateDocumentApprovingState = state

        switch state {
        case .initial:
            privateDocumentButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "chevronRight")
                imageView.tintColor = .darkIndigo
            })
        case .onVerification:
            privateDocumentButton?.custom.changeState(to: 1, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icTime")
                imageView.tintColor = .white
            })
        case .verified:
            privateDocumentButton?.custom.changeState(to: 2, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icCheck")
                imageView.tintColor = .white
            })
        }
    }

    func updateSelfieApprovingState(_ state: KYCApprovingState) {
        self.selfieApprovingState = state

        switch state {
        case .initial:
            selfieButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "chevronRight")
                imageView.tintColor = .darkIndigo
            })
        case .onVerification:
            selfieButton?.custom.changeState(to: 1, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icTime")
                imageView.tintColor = .white
            })
        case .verified:
            selfieButton?.custom.changeState(to: 2, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icCheck")
                imageView.tintColor = .white
            })
        }
    }

    func updateAddressDocumentApprovingState(_ state: KYCApprovingState) {
        self.addressDocumentApprovingState = state

        switch state {
        case .initial:
            addressDocumentButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "chevronRight")
                imageView.tintColor = .darkIndigo
            })
        case .onVerification:
            addressDocumentButton?.custom.changeState(to: 1, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icTime")
                imageView.tintColor = .white
            })
        case .verified:
            addressDocumentButton?.custom.changeState(to: 2, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icCheck")
                imageView.tintColor = .white
            })
        }
    }

    @objc
    private func document01ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onFirstDocument?()
    }

    @objc
    private func document02ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onSecondDocument?()
    }

    @objc
    private func document03ButtonTouchUpInsideEvent(_ sender: StageButton) {
        onThirdDocument?()
    }
}
