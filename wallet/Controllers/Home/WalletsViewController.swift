//
//  WalletsViewController.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Crashlytics
import Hero

typealias WalletsCollectionViewController = (UIViewController & WalletsCollection)

/**
 Protocol that provides interface to control wallets collection from outside.
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

/**
 Delegate that provides callbacks for updating data and scrolling collection view.
 */
protocol WalletsViewControllerDelegate: class {

    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController)

    func walletsViewControllerScrollingEvent(_ walletsViewController: WalletsViewController, panGestureRecognizer: UIPanGestureRecognizer, offset: CGPoint)
}

/**
 Wallets collection screen that controls it's behavior like "pull to refresh" and provides callbacks for it.
 */
class WalletsViewController: FlowCollectionViewController {

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?
    var historyAPI: HistoryAPI?

    private weak var _owner: HomeController?
    private weak var _delegate: WalletsViewControllerDelegate?

    private var didInitiallyLoaded: Bool = false

    private var wallets: [Wallet] = []
    private var walletsChartsPoints: [[ChartLayer.Coordinate]] = []
    private var phone: String!

    private var zamIndex: Int?

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

        loadData()

        collectionView?.panGestureRecognizer.addTarget(self, action: #selector(collectionViewPanGestureEvent(recognizer:)))
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

    // MARK: - RefreshControl update event

    @objc
    private func refreshControlValueChangedEvent(_ sender: Any) {
        _delegate?.walletsViewControllerCallsUpdateData(self)

        loadData()
    }

    // MARK: - Load data

    /**
     Load wallets, assign it to private property and update collection view.
     */
    private func loadData() {
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

            strongSelf.wallets = wallets
            strongSelf.zamIndex = wallets.index(where: { $0.coin == .zam })
            strongSelf.didInitiallyLoaded = true

            strongSelf.loadChartsPoints(for: wallets, completion: {
                _ in

                strongSelf.collectionView?.reloadData()
                strongSelf.refreshControl?.endRefreshing()
            })
        }.catch {
            [weak self]
            error in
            Crashlytics.sharedInstance().recordError(error)
            
            self?.refreshControl?.endRefreshing()
        }
    }

    /**
     Load wallets history points to build chart, assign it to private property and call completion block.
     */
    private func loadChartsPoints(for wallets: [Wallet], completion: @escaping ([[ChartLayer.Coordinate]]) -> Void) {
        guard let historyAPI = historyAPI else {
            return
        }

        self.walletsChartsPoints = [[ChartLayer.Coordinate]](repeating: [], count: wallets.count)

        let group = DispatchGroup()
        for (index, wallet) in wallets.enumerated() {

            guard wallet.coin != .zam else {
                continue
            }

            group.enter()

            historyAPI.getHistoricalDailyPrice(for: wallet.coin, count: 30).done {
                [weak self]
                days in

                self?.walletsChartsPoints[index] = days.map {
                    return ChartLayer.Coordinate(x: $0.time.unixTimestamp,
                                            y: Double(truncating: $0.closePrice as NSNumber))
                }
                group.leave()
            }.catch {
                [weak self]
                error in

                Crashlytics.sharedInstance().recordError(error)

                self?.walletsChartsPoints[index] = []
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(self.walletsChartsPoints)
        }
    }

    // MARK: - Animation
    
    private func prepareCellForAnimation(_ cell: WalletSmallItemComponent) {
        collectionView.visibleCells.compactMap {
            return $0 as? WalletSmallItemComponent
        }.forEach {
            $0.removeTargetToAnimation()
        }

        cell.setTargetToAnimation()
    }
}

// MARK: - Extensions

/**
 Extension implements WalletsCollection protocol. It's interface to control some properties of WalletsViewController from outside.
 */
extension WalletsViewController: WalletsCollection {

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
        loadData()
    }
}

/**
 Overriding UICollectionViewDataSource methods
 */
extension WalletsViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If wallets weren't loaded before show 3 skeleton cells.
        guard didInitiallyLoaded else {
            return 3
        }

        return wallets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletItemComponent", for: indexPath)

        guard let cell = _cell as? WalletItemComponent else {
            fatalError()
        }

        // If wallets weren't loaded before show cell skeleton.
        guard didInitiallyLoaded else {
            cell.stiffen()
            return cell
        }

        let itemData = WalletItemData(data: wallets[indexPath.item], phoneNumber: phone)

        // Find zam wallet, prepare for not showing it on wallet details.
        var detailsWallets = self.wallets
        var detailsIndex = indexPath.item

        if let zamIndex = self.zamIndex {
            detailsWallets = self.wallets.filter({ $0.coin != .zam })

            if indexPath.item > zamIndex {
                detailsIndex = indexPath.item - 1
            }
        }

        // Turn off skeleton mode for cell
        cell.relive()

        cell.configure(with: itemData)

        cell.setupChart(points: walletsChartsPoints[indexPath.item])

        // Send button tap event
        cell.onSendButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.prepareCellForAnimation(cell)
            owner.performSendFromWallet(index: indexPath.item, wallets: strongSelf.wallets, phone: strongSelf.phone, recipient: nil)
        }

        // Deposit button tap event
        cell.onDepositButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.prepareCellForAnimation(cell)
            owner.performDepositFromWallet(index: indexPath.item, wallets: strongSelf.wallets, phone: strongSelf.phone)
        }

        // If coin isn't wallet assign non-empty card long press event
        if wallets[indexPath.item].coin == .zam {
            cell.onCardLongPress = {}
        } else {
            cell.onCardLongPress = {
                [weak self] in

                guard let strongSelf = self, let owner = strongSelf._owner else {
                    return
                }

                strongSelf.prepareCellForAnimation(cell)
                owner.performWalletDetails(index: detailsIndex, wallets: detailsWallets, phone: strongSelf.phone)
            }
        }
        return cell
    }
}

/**
 Extension implements UICollectionViewDelegateFlowLayout protocol.
 */
extension WalletsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 134.0)
    }
}
