//
//  WalletsViewController.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

typealias WalletsCollectionViewController = (UIViewController & WalletsCollection)

/**
 Protocol that provides interface to control wallets collection from it's owner screen.
 */
protocol WalletsCollection {

    var delegate: WalletsViewControllerDelegate? { get set }

    var owner: ScreenWalletNavigable? { get set }

    var isTopExpanded: Bool { get }

    var isScrollEnabled: Bool { get set }

    func setContentInsets(_ insets: UIEdgeInsets)

    func scrollToTop()

    func sendWithContact(_ contact: FormattedContactData)
}

protocol WalletsViewControllerDelegate: class {

    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController)

    func walletsViewControllerScrollingEvent(_ walletsViewController: WalletsViewController, panGestureRecognizer: UIPanGestureRecognizer, offset: CGPoint)
}

class WalletsViewController: FlowCollectionViewController, UICollectionViewDelegateFlowLayout, SendMoneyViewControllerDelegate, WalletsCollection {

    private weak var _owner: ScreenWalletNavigable?
    private weak var _delegate: WalletsViewControllerDelegate?

    var onSendFromWallet: ((_ index: Int, _ wallets: [WalletData], _ recipient: FormattedContactData?, _ phone: String, _ owner: ScreenWalletNavigable) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [WalletData], _ phone: String, _ owner: ScreenWalletNavigable) -> Void)?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?
    var historyAPI: HistoryAPI?

    private var wallets: [WalletData] = []
    private var walletsChartsPoints: [[ChartLayer.Point]] = []
    private var phone: String?

    private var refreshControl: UIRefreshControl?

    private var savedWalletsContentOffset: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        collectionView?.backgroundColor = .clear

        collectionView?.register(WalletItemComponent.self , forCellWithReuseIdentifier: "WalletItemComponent")
        collectionView?.delegate = self
        collectionView?.dataSource = self

        phone = userManager?.getPhoneNumber()

        loadData(self)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChangedEvent(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -2
        collectionView?.insertSubview(refreshControl!, at: 0)

        collectionView?.panGestureRecognizer.addTarget(self, action: #selector(collectionViewPanGestureEvent(recognizer:)))
    }

    // MARK: - WalletsCollection

    var delegate: WalletsViewControllerDelegate? {
        get {
            return _delegate
        }

        set {
            _delegate = newValue
        }
    }

    var owner: ScreenWalletNavigable? {
        get {
            return _owner
        }

        set {
            _owner = newValue
        }
    }

    var isTopExpanded: Bool {
        return collectionView.contentOffset.y < -collectionView.contentInset.top
    }

    var isScrollEnabled: Bool {
        get {
            return collectionView.isScrollEnabled
        }

        set {
            collectionView.isScrollEnabled = newValue
        }
    }

    func setContentInsets(_ insets: UIEdgeInsets) {
        collectionView.contentInset = insets
    }

    func scrollToTop() {
        let newContentOffset = CGPoint(x: 0.0, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(newContentOffset, animated: false)
    }

    func sendWithContact(_ contact: FormattedContactData) {
        guard let phone = phone, let owner = _owner else {
            return
        }

        onSendFromWallet?(0, wallets, contact, phone, owner)
    }

    // MARK: - UIPanGestureRecognizer

    @objc
    func collectionViewPanGestureEvent(recognizer: UIPanGestureRecognizer) {
        guard let collectionView = collectionView else {
            return
        }

        let translation = recognizer.translation(in: collectionView)
        let clearOffset = CGPoint(x: translation.x, y: translation.y + collectionView.contentInset.top - collectionView.contentInset.bottom)

        _delegate?.walletsViewControllerScrollingEvent(self, panGestureRecognizer: recognizer, offset: clearOffset)
    }

    // MARK: - UICollectionViewDataSource

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

        let size = CGSize(width: collectionView.bounds.width - 32, height: 120.0)

//        let chart = ChartLayer(size: size, points: [
//            ChartLayer.Point(x: 1535846400, y: 7301.26),
//            ChartLayer.Point(x: 1535932800, y: 7270.05),
//            ChartLayer.Point(x: 1536019200, y: 7369.86),
//            ChartLayer.Point(x: 1536105600, y: 6705.03),
//            ChartLayer.Point(x: 1536192000, y: 6411.78),
//            ChartLayer.Point(x: 1536364800, y: 6200.16),
//            ChartLayer.Point(x: 1536451200, y: 6249.07),
//            ChartLayer.Point(x: 1536537600, y: 6324.43),
//            ChartLayer.Point(x: 1536624000, y: 6295.54),
//            ChartLayer.Point(x: 1536710400, y: 6337.11),
//            ChartLayer.Point(x: 1536796800, y: 6492),
//            ChartLayer.Point(x: 1536883200, y: 6486.01),
//            ChartLayer.Point(x: 1536969600, y: 6522.08),
//            ChartLayer.Point(x: 1537056000, y: 6502.44),
//            ChartLayer.Point(x: 1537142400, y: 6261.48),
//            ChartLayer.Point(x: 1537228800, y: 6346.44),
//            ChartLayer.Point(x: 1537315200, y: 6398.8),
//            ChartLayer.Point(x: 1537401600, y: 6505.9)
//            ])

        let chart = ChartLayer(size: size, points: walletsChartsPoints[indexPath.item])
        chart.insets = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 20.0, right: 0.0)
        cell.setupChart(layer: chart)

        let wallet = wallets[indexPath.item]
        cell.configure(image: wallet.coin.image,
                       coinName: wallet.coin.name,
                       coinAddit: wallet.coin.short, phoneNumber: phone, balance: wallet.balance.formatted(currency: .original), fiatBalance: wallet.balance.description(currency: .usd))
        cell.onSendButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.onSendFromWallet?(indexPath.item, strongSelf.wallets, nil, phone, owner)
        }
        cell.onDepositButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.onDepositToWallet?(indexPath.item, strongSelf.wallets, phone, owner)
        }
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: 134.0)
    }

    // MARK: - SendMoneyViewControllerDelegate

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        refreshControlValueChangedEvent(self)
    }

    @objc
    private func refreshControlValueChangedEvent(_ sender: Any) {
        _delegate?.walletsViewControllerCallsUpdateData(self)
        loadData(sender)
    }

    private func loadData(_ sender: Any) {
        guard let token = userManager?.getToken() else {
            return
        }

        userAPI?.getWallets(token: token).done {
            [weak self]
            wallets in

            self?.wallets = wallets
            self?.walletsChartsPoints = [[ChartLayer.Point]](repeating: [], count: 30)

            let group = DispatchGroup()

            wallets.enumerated().forEach({
                w in

                group.enter()

                self?.historyAPI?.getHistoricalDailyData(for: w.element.coin, days: 30).done {
                    days in

                    self?.walletsChartsPoints[w.offset] = days.map( { return ChartLayer.Point(x: $0.time.unixTimestamp, y: Double(truncating: $0.closePrice as NSNumber)) })
                    group.leave()
                }.catch {
                    error in
                }
            })

            group.notify(queue: .main) {
                self?.collectionView?.reloadData()
                self?.refreshControl?.endRefreshing()
            }
        }.catch {
            [weak self]
            error in

            self?.refreshControl?.endRefreshing()
        }
    }
}
