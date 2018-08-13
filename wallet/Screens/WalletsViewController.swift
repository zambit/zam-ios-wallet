//
//  WalletsViewController.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletsViewController: FlowCollectionViewController, UICollectionViewDelegateFlowLayout, WalletsContainerEmbededViewController {

    var userManager: UserDataManager?
    var userAPI: UserAPI?

    private var wallets: [WalletData] = []

    private var refreshControl: UIRefreshControl?

    private var phone: String?

    var scrollView: UIScrollView? {
        return collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(WalletItemComponent.self , forCellWithReuseIdentifier: "WalletItemComponent")
        collectionView?.delegate = self
        collectionView?.dataSource = self

        phone = userManager?.getPhoneNumber()

        loadData(self)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -2
        collectionView?.insertSubview(refreshControl!, at: 0)
    }

    // UICollectionView dataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletItemComponent", for: indexPath)

        guard let cell = _cell as? WalletItemComponent else {
            fatalError()
        }

        guard let phone = phone else {
            fatalError()
        }

        let wallet = wallets[indexPath.item]
        cell.configure(image: wallet.coin.image, coinName: wallet.coin.name, coinAddit: wallet.coin.short, phoneNumber: phone, balance: wallet.balance.original, fiatBalance: wallet.balance.usd)
        return cell
    }

    // UICollectionView delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            return CGSize(width: collectionView.bounds.width, height: 100.0)
        case .extra, .medium, .plus:
            return CGSize(width: collectionView.bounds.width, height: 134.0)
        case .unknown:
            fatalError()
        }
    }

    @objc
    private func loadData(_ sender: Any) {
        guard let token = userManager?.getToken() else {
            fatalError()
        }

        userAPI?.getWallets(token: token).done {
            [weak self]
            wallets in

            self?.wallets = wallets
            self?.collectionView?.reloadData()
            self?.refreshControl?.endRefreshing()
        }.catch {
            [weak self]
            error in
            print(error)
        }
    }
}