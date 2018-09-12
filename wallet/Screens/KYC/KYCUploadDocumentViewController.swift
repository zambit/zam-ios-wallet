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

    var onSend: ((KYCStatus) -> Void)?

    private(set) var documentsImages: [UIImage?] = []

    private var approvingState: KYCStatus = .unloaded

    @IBOutlet private var backgroundView: UIView?

    @IBOutlet private var topPlaceholderComponent: IllustrationalPlaceholder?
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var detailTextLabel: UILabel?
    @IBOutlet private var documentButtonsStackView: UIStackView?

    @IBOutlet private var sendButton: StageButton?

    var sendingState: KYCStatus = .unloaded

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

        documentsImages = [UIImage?](repeating: nil, count: documentButtonsCount)

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
            StageDescription(description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)])

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

        for i in 0..<count {
            let documentButton = PhotoButton(type: .custom)

            documentButton.tag = 1680 + i

            documentButton.translatesAutoresizingMaskIntoConstraints = false
            documentButton.heightAnchor.constraint(equalTo: documentButton.widthAnchor).isActive = true
            documentButton.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
            documentButton.addTarget(self, action: #selector(documentButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

            documentButtonsStackView?.addArrangedSubview(documentButton)
        }
    }

    func prepare(state: KYCStatus) {
        self.approvingState = state

        switch state {
        case .unloaded:
            sendButton?.custom.changeState(to: 0)
        case .pending:
            sendButton?.custom.changeState(to: 1)
        case .verified:
            sendButton?.custom.changeState(to: 2)
        }
    }

    @objc
    func sendButtonTouchUpInsideEvent(_ sender: StageButton) {
        onSend?(.pending)
    }

    @objc
    private func documentButtonTouchUpInsideEvent(_ sender: PhotoButton) {
        addPhoto(for: sender, index: sender.tag % 10)
    }

    private var currentProceedDocumentIndex: Int?
    private weak var currentProceedDocumentButton: PhotoButton?

    private func addPhoto(for button: PhotoButton, index: Int) {
        let alert = UIAlertController(style: .actionSheet)
        alert.addMediaSheetPicker {
            [weak self]
            result in

            switch result {
            case .cameraLibraryRequest:
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    return
                }

                self?.currentProceedDocumentIndex = index
                self?.currentProceedDocumentButton = button

                let photoLibraryPickerController = UIImagePickerController()
                photoLibraryPickerController.delegate = self;
                photoLibraryPickerController.sourceType = .camera
                self?.present(photoLibraryPickerController, animated: true, completion: nil)

            case .photosLibraryRequest:
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    return
                }

                self?.currentProceedDocumentIndex = index
                self?.currentProceedDocumentButton = button

                let photoLibraryPickerController = UIImagePickerController()
                photoLibraryPickerController.delegate = self;
                photoLibraryPickerController.sourceType = .photoLibrary
                self?.present(photoLibraryPickerController, animated: true, completion: nil)

            case .photos(let assets):

                guard let strongSelf = self else {
                    return
                }

                let image = assets.first?.thumbnailImage
                strongSelf.documentsImages[index] = image
                strongSelf.documentsImagesChanged(strongSelf.documentsImages)
                if let img = image {
                    button.custom.setup(photo: img)
                }
            }
        }

        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
    }

    func documentsImagesChanged(_ documentsImages: [UIImage?]) {
        let unwrapped: [UIImage] = documentsImages.compactMap { return $0 }

        sendButton?.custom.setEnabled(unwrapped.count == documentButtonsCount)
    }
}

extension KYCUploadDocumentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {
            [weak self] in
            self?.currentProceedDocumentIndex = nil
            self?.currentProceedDocumentButton = nil
        })
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let index = currentProceedDocumentIndex,
            let button = currentProceedDocumentButton {

            self.documentsImages[index] = image
            self.documentsImagesChanged(self.documentsImages)
            button.custom.setup(photo: image)
        } else {
            print("Something went wrong")
        }

        self.dismiss(animated: true, completion: {
            [weak self] in
            self?.currentProceedDocumentIndex = nil
            self?.currentProceedDocumentButton = nil
        })
    }
}
