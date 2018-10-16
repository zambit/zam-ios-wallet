//
//  WalletsViewController.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Hero

typealias WalletsCollectionViewController = (UIViewController & WalletsCollection)

/**
 Protocol that provides interface to control wallets collection from it's owner screen.
 */
protocol WalletsCollection {

    var delegate: WalletsViewControllerDelegate? { get set }

    var owner: HomeController? { get set }

    var isTopExpanded: Bool { get }

    var isScrollEnabled: Bool { get set }

    var contentInsets: UIEdgeInsets { get set }

    func scrollToTop()

    func sendTo(contact: FormattedContact)

    func prepareToAnimation(cellIndex: Int)

    func reload()
}

protocol WalletsViewControllerDelegate: class {

    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController)

    func walletsViewControllerScrollingEvent(_ walletsViewController: WalletsViewController, panGestureRecognizer: UIPanGestureRecognizer, offset: CGPoint)
}

class WalletsViewController: FlowCollectionViewController, UICollectionViewDelegateFlowLayout, WalletsCollection {

    private weak var _owner: HomeController?
    private weak var _delegate: WalletsViewControllerDelegate?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?
    var historyAPI: HistoryAPI?

    private var didInitiallyLoaded: Bool = false

    private var wallets: [Wallet] = []
    private var walletsChartsPoints: [[ChartLayer.Point]] = []
    private var phone: String!

    private var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        collectionView?.backgroundColor = .clear

        collectionView?.register(WalletItemComponent.self , forCellWithReuseIdentifier: "WalletItemComponent")
        collectionView?.delegate = self
        collectionView?.dataSource = self

        guard let phone = userManager?.getPhoneNumber() else {
            fatalError()
        }
        self.phone = phone

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChangedEvent(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -2
        collectionView?.refreshControl = refreshControl

        loadData(self)

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

    var owner: HomeController? {
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

    var contentInsets: UIEdgeInsets {
        get {
            return collectionView.contentInset
        }

        set {
            collectionView.contentInset = newValue
        }
    }

    func scrollToTop() {
        let newContentOffset = CGPoint(x: 0.0, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(newContentOffset, animated: false)
    }

    func sendTo(contact: FormattedContact) {
        guard wallets.count > 0 else {
            return
        }
        
        prepareToAnimation(cellIndex: 0)
        owner?.performSendFromWallet(index: 0, wallets: wallets, phone: phone, recipient: contact)
    }

    func prepareToAnimation(cellIndex: Int) {
        let indexPath = IndexPath(item: cellIndex, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? WalletSmallItemComponent else {
            return
        }

        prepareCellForAnimation(cell)
    }

    func reload() {
        loadData(self)
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
        guard didInitiallyLoaded else {
            return 4
        }

        return wallets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletItemComponent", for: indexPath)

        guard let cell = _cell as? WalletItemComponent else {
            fatalError()
        }

        guard didInitiallyLoaded else {
            cell.stiffen()
            return cell
        }

        let itemData = WalletItemData(data: wallets[indexPath.item], phoneNumber: phone)

        cell.relive()
        
        cell.configure(with: itemData)
        
        cell.setupChart(points: walletsChartsPoints[indexPath.item])

        cell.onSendButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.prepareCellForAnimation(cell)
            owner.performSendFromWallet(index: indexPath.item, wallets: strongSelf.wallets, phone: strongSelf.phone, recipient: nil)
        }

        cell.onDepositButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.prepareCellForAnimation(cell)
            owner.performDepositFromWallet(index: indexPath.item, wallets: strongSelf.wallets, phone: strongSelf.phone)
        }

        cell.onCardLongPress = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.prepareCellForAnimation(cell)
            owner.performWalletDetails(index: indexPath.item, wallets: strongSelf.wallets, phone: strongSelf.phone)
        }
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 134.0)
    }

    // MARK: - Refresh

    @objc
    private func refreshControlValueChangedEvent(_ sender: Any) {
        _delegate?.walletsViewControllerCallsUpdateData(self)
        loadData(sender)
    }

    // MARK: - Load data

    /**
     Load wallets, assign it to private property and update collection view.
     */
    private func loadData(_ sender: Any) {
        guard let token = userManager?.getToken() else {
            refreshControl?.endRefreshing()
            return
        }

        userAPI?.getWallets(token: token).done {
            [weak self]
            wallets in

            guard let strongSelf = self else {
                return
            }

            let oldCount = strongSelf.wallets.count
            let newCount = wallets.count

            strongSelf.wallets = wallets
            strongSelf.didInitiallyLoaded = true

            if oldCount != newCount {

                strongSelf.loadChartsPoints(completion: {
                    _ in

                    strongSelf.collectionView?.reloadData()
                    strongSelf.refreshControl?.endRefreshing()
                })
            } else {
                strongSelf.collectionView?.reloadData()
                strongSelf.refreshControl?.endRefreshing()
            }
        }.catch {
            [weak self]
            error in

            self?.refreshControl?.endRefreshing()
        }
    }

    /**
     Load wallets history points to build chart, assign it to private property and call completion block.
     */
    private func loadChartsPoints(completion: @escaping ([[ChartLayer.Point]]) -> Void) {
        guard let historyAPI = historyAPI else {
            return
        }

        self.walletsChartsPoints = [[ChartLayer.Point]](repeating: [], count: wallets.count)

        let group = DispatchGroup()
        for i in wallets.enumerated() {
            group.enter()

            historyAPI.getHistoricalDailyData(for: i.element.coin, days: 30).done {
                [weak self]
                days in

                self?.walletsChartsPoints[i.offset] = days.map {
                    return ChartLayer.Point(x: $0.time.unixTimestamp,
                                            y: Double(truncating: $0.closePrice as NSNumber))
                }
                group.leave()
            }.catch {
                error in

                Crashlytics.sharedInstance().recordError(error)
                
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(self.walletsChartsPoints)
        }
    }

    private func prepareCellForAnimation(_ cell: WalletSmallItemComponent) {
        collectionView.visibleCells.compactMap {
            return $0 as? WalletSmallItemComponent
        }.forEach {
            $0.removeTargetToAnimation()
        }

        cell.setTargetToAnimation()
    }
}
