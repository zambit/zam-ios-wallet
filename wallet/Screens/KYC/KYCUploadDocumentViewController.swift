//
//  KYCUploadDocumentViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCUploadDocumentViewController: FlowViewController, WalletNavigable {

    var onSend: ((KYCApprovingState) -> Void)?

    @IBOutlet private var backgroundView: UIView?

    @IBOutlet private var topPlaceholderComponent: IllustrationalPlaceholder?
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var detailTextLabel: UILabel?
    @IBOutlet private var documentButtonsStackView: UIStackView?

    @IBOutlet private var sendButton: StageButton?

    var sendingState: KYCApprovingState = .initial

    var descriptionTitle: String {
        return "Title"
    }

    var descriptionText: String {
        return "Text"
    }

    var documentButtonsCount: Int {
        return 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView?.backgroundColor = .white
        view.applyDefaultGradientHorizontally()

        topPlaceholderComponent?.text = ""

        titleLabel?.font = UIFont.walletFont(ofSize: 28.0, weight: .bold)
        titleLabel?.textColor = .black
        titleLabel?.numberOfLines = 0
        titleLabel?.text = descriptionTitle

        detailTextLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        detailTextLabel?.textColor = UIColor.black.withAlphaComponent(0.2)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.text = descriptionText

        sendButton?.custom.setup(type: .small, stages: [
            StageDescription(id: nil, idTextColor: nil, description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue)])

        sendButton?.custom.setEnabled(false)
        sendButton?.addTarget(self, action: #selector(sendButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        documentButtonsStackView?.alignment = .leading
        documentButtonsStackView?.axis = .horizontal
        documentButtonsStackView?.distribution = .equalSpacing
        documentButtonsStackView?.spacing = 24.0

        setupDocumentButtons(count: documentButtonsCount)
    }

    private func setupDocumentButtons(count: Int) {
        documentButtonsStackView?.subviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<count {
            let documentButton = PhotoButton(type: .custom)

            documentButton.translatesAutoresizingMaskIntoConstraints = false
            documentButton.heightAnchor.constraint(equalTo: documentButton.widthAnchor).isActive = true
            documentButton.heightAnchor.constraint(equalToConstant: 90.0).isActive = true

            documentButtonsStackView?.addArrangedSubview(documentButton)
        }
    }

    @objc
    func sendButtonTouchUpInsideEvent(_ sender: StageButton) {
        //onSend?(.onVerification)
    }
}
