//
//  MediaSheetPickerViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Photos

typealias MediaSheetSelection = (MediaSelectionType) -> ()

enum MediaSelectionType {

    case photos([PHAsset])
    case photosLibraryRequest
    case cameraLibraryRequest
}

extension UIAlertController {

    /// Add Telegram Picker
    ///
    /// - Parameters:
    ///   - selection: type and action for selection of asset/assets

    func addMediaSheetPicker(selection: @escaping MediaSheetSelection) {
        let vc = MediaSheetPickerViewController(selection: selection)
        set(vc: vc)
    }
}

final class MediaSheetPickerViewController: UIViewController {

    var buttons: [ButtonType] {
        return [.photos, .camera]
    }

    enum ButtonType {
        case camera
        case photos
    }

    // MARK: UI

    struct UI {
        static let rowHeight: CGFloat = 58
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let minimumInteritemSpacing: CGFloat = 6
        static let minimumLineSpacing: CGFloat = 6
        static let maxHeight: CGFloat = UIScreen.main.bounds.width / 2
        static let multiplier: CGFloat = 2
        static let animationDuration: TimeInterval = 0.3
    }

    func title(for button: ButtonType) -> String {
        switch button {
        case .photos: return "Library"
        case .camera: return "Camera"
        //case .sendPhotos: return "Send \(selectedAssets.count) \(selectedAssets.count == 1 ? "Photo" : "Photos")"
        }
    }

    func font(for button: ButtonType) -> UIFont {
        switch button {
        default: return UIFont.systemFont(ofSize: 20)
        }
    }

    var preferredHeight: CGFloat {
        return UI.maxHeight / (selectedAssets.count == 0 ? UI.multiplier : 1) + UI.insets.top + UI.insets.bottom
    }

    func sizeFor(asset: PHAsset) -> CGSize {
        let height: CGFloat = UI.maxHeight
        let width: CGFloat = CGFloat(Double(height) * Double(asset.pixelWidth) / Double(asset.pixelHeight))
        return CGSize(width: width, height: height)
    }

    func sizeForItem(asset: PHAsset) -> CGSize {
        let size: CGSize = sizeFor(asset: asset)
        if selectedAssets.count == 0 {
            let value: CGFloat = size.height / UI.multiplier
            return CGSize(width: value, height: value)
        } else {
            return size
        }
    }

    // MARK: Properties

    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = UI.minimumLineSpacing
        return flowLayout
    }()

    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = UIScrollView.DecelerationRate.fast
        //$0.contentInsetAdjustmentBehavior = .never
        $0.contentInset = UI.insets
        $0.backgroundColor = .clear
        $0.maskToBounds = false
        $0.clipsToBounds = false
        $0.register(ItemWithPhoto.self, forCellWithReuseIdentifier: String(describing: ItemWithPhoto.identifier))

        return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout))

    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UIColor.lightGray.withAlphaComponent(0.4)
        $0.separatorInset = .zero
        $0.backgroundColor = nil
        $0.bounces = false
        $0.tableHeaderView = collectionView
        $0.tableFooterView = UIView()
        $0.register(LikeButtonCell.self, forCellReuseIdentifier: LikeButtonCell.identifier)

        return $0
        }(UITableView(frame: .zero, style: .plain))

    lazy var assets = [PHAsset]()
    lazy var selectedAssets = [PHAsset]()

    var selection: MediaSheetSelection?

    // MARK: Initialize

    required init(selection: @escaping MediaSheetSelection) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width * 0.5
        }

        updatePhotos()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }

    func layoutSubviews() {
        tableView.tableHeaderView?.height = preferredHeight
        preferredContentSize.height = tableView.contentSize.height
    }

    func updatePhotos() {
        checkStatus { [unowned self] assets in

            self.assets.removeAll()
            self.assets.append(contentsOf: assets)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }

    func checkStatus(completionHandler: @escaping ([PHAsset]) -> ()) {
        switch PHPhotoLibrary.authorizationStatus() {

        case .notDetermined:
            /// This case means the user is prompted for the first time for allowing contacts
            PickersAssets.requestAccess { [unowned self] status in
                self.checkStatus(completionHandler: completionHandler)
            }

        case .authorized:
            /// Authorization granted by user for this app.
            DispatchQueue.main.async {
                self.fetchPhotos(completionHandler: completionHandler)
            }

        case .denied, .restricted:
            /// User has denied the current app to access the contacts.
            let productName = Bundle.main.infoDictionary!["CFBundleName"]!
            let alert = UIAlertController(title: "Permission denied", message: "\(productName) does not have access to contacts. Please, allow the application to access to your photo library.", preferredStyle: .alert)
            alert.addAction(title: "Settings", style: .destructive) { action in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            alert.addAction(title: "OK", style: .cancel) { [unowned self] action in
                self.alertController?.dismiss(animated: true)
            }
            alert.show()
        }
    }

    func fetchPhotos(completionHandler: @escaping ([PHAsset]) -> ()) {
        PickersAssets.fetch { [unowned self] result in
            switch result {

            case .success(let assets):
                completionHandler(assets)

            case .error(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(title: "OK") { [unowned self] action in
                    self.alertController?.dismiss(animated: true)
                }
                alert.show()
            }
        }
    }

    func action(withAsset asset: PHAsset, at indexPath: IndexPath) {
        alertController?.dismiss(animated: true) { [unowned self] in
            self.selection?(MediaSelectionType.photos([asset]))
        }
    }

    func action(for button: ButtonType) {
        switch button {
        case .photos:
            alertController?.dismiss(animated: true) { [weak self] in
                self?.selection?(MediaSelectionType.photosLibraryRequest)
            }

        case .camera:
            alertController?.dismiss(animated: true) { [weak self] in
                self?.selection?(MediaSelectionType.cameraLibraryRequest)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MediaSheetPickerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size: CGSize = sizeForItem(asset: assets[indexPath.item])
        return size
    }
}

// MARK: - UICollectionViewDelegate

extension MediaSheetPickerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action(withAsset: assets[indexPath.item], at: indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension MediaSheetPickerViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _item = collectionView.dequeueReusableCell(withReuseIdentifier: ItemWithPhoto.identifier, for: indexPath)

        guard let item = _item as? ItemWithPhoto else {
            return UICollectionViewCell()
        }

        let asset = assets[indexPath.item]
        let size = sizeFor(asset: asset)

        item.custom.setup(style: .exclusive)

        DispatchQueue.main.async {
            PickersAssets.resolve(asset: asset, size: size) { new in
                item.custom.set(image: new)
            }
        }

        return item
    }
}

// MARK: - UITableViewDelegate

extension MediaSheetPickerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.action(for: self.buttons[indexPath.row])
        }
    }
}

// MARK: - UITableViewDataSource

extension MediaSheetPickerViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeButtonCell.identifier) as! LikeButtonCell
        cell.textLabel?.font = font(for: buttons[indexPath.row])
        cell.textLabel?.text = title(for: buttons[indexPath.row])
        return cell
    }
}
