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

    private var privateDocumentApprovingState: KYCStatus = .unloaded
    private var selfieApprovingState: KYCStatus = .unloaded
    private var addressDocumentApprovingState: KYCStatus = .unloaded

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView?.backgroundColor = .white
        view.applyDefaultGradientHorizontally()

        let document01Stages = [
            StageDescription(id: "01", idTextColor: .azure, description: "Photos passport, or ID card, or Driving license", descriptionTextColor: .darkIndigo, backgroundColor: .white, image: #imageLiteral(resourceName: "chevronRight"), imageTintColor: .darkIndigo),
            StageDescription(id: "01", idTextColor: nil, description: "Photos passport, or ID card, or Driving license", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(id: "01", idTextColor: nil, description: "Photos passport, or ID card, or Driving license", descriptionTextColor: .white, backgroundColor: .paleOliveGreen, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)]
        privateDocumentButton?.custom.setup(type: .medium, stages: document01Stages)
        privateDocumentButton?.custom.changeState(to: 0)
        privateDocumentButton?.addTarget(self, action: #selector(document01ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        let document02Stages = [
            StageDescription(id: "02", idTextColor: .azure, description: "Selfie of a customer holding the above document", descriptionTextColor: .darkIndigo, backgroundColor: .white, image: #imageLiteral(resourceName: "chevronRight"), imageTintColor: .darkIndigo),
            StageDescription(id: "02", idTextColor: nil, description: "Selfie of a customer holding the above document", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(id: "02", idTextColor: nil, description: "Selfie of a customer holding the above document", descriptionTextColor: .white, backgroundColor: .paleOliveGreen, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)]
        selfieButton?.custom.setup(type: .medium, stages: document02Stages)
        selfieButton?.custom.changeState(to: 0)
        selfieButton?.addTarget(self, action: #selector(document02ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)


        let document03Stages = [
            StageDescription(id: "03", idTextColor: .azure, description: "Upload document confirming address of residence", descriptionTextColor: .darkIndigo, backgroundColor: .white, image: #imageLiteral(resourceName: "chevronRight"), imageTintColor: .darkIndigo),
            StageDescription(id: "03", idTextColor: nil, description: "Upload document confirming address of residence", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(id: "03", idTextColor: nil, description: "Upload document confirming address of residence", descriptionTextColor: .white, backgroundColor: .paleOliveGreen, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)]
        addressDocumentButton?.custom.setup(type: .medium, stages: document03Stages)
        addressDocumentButton?.custom.changeState(to: 0)
        addressDocumentButton?.addTarget(self, action: #selector(document03ButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func prepare(privateDocumentApprovingState: KYCStatus, selfieApprovingState: KYCStatus, addressDocumentApprovingState: KYCStatus) {
        self.updatePrivateDocumentApprovingState(privateDocumentApprovingState)
        self.updateSelfieApprovingState(selfieApprovingState)
        self.updateAddressDocumentApprovingState(addressDocumentApprovingState)
    }

    func updatePrivateDocumentApprovingState(_ state: KYCStatus) {
        self.privateDocumentApprovingState = state

        switch state {
        case .unloaded:
            privateDocumentButton?.custom.changeState(to: 0)
        case .pending:
            privateDocumentButton?.custom.changeState(to: 1)
        case .verified:
            privateDocumentButton?.custom.changeState(to: 2)
        }
    }

    func updateSelfieApprovingState(_ state: KYCStatus) {
        self.selfieApprovingState = state

        switch state {
        case .unloaded:
            selfieButton?.custom.changeState(to: 0)
        case .pending:
            selfieButton?.custom.changeState(to: 1)
        case .verified:
            selfieButton?.custom.changeState(to: 2)
        }
    }

    func updateAddressDocumentApprovingState(_ state: KYCStatus) {
        self.addressDocumentApprovingState = state

        switch state {
        case .unloaded:
            addressDocumentButton?.custom.changeState(to: 0)
        case .pending:
            addressDocumentButton?.custom.changeState(to: 1)
        case .verified:
            addressDocumentButton?.custom.changeState(to: 2)
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
