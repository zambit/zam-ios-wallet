//
//  OnboardingViewController.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Onboarding screen.
 */
class OnboardingViewController: FlowViewController, WalletNavigable, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /**
     Flow parameter for moving to login flow
     */
    var onLogin: (() -> Void)?
    /**
     Flow parameter for moving to signup flow
     */
    var onSignup: (() -> Void)?

    /**
     Pages of the onboarding CollectionView
     */
    private var onboardingItems: [OnboardingItemData] = []

    @IBOutlet var pagesCollectionView: UICollectionView?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var registrationButton: OnboardingLargeButton?
    @IBOutlet var loginButton: UIButton?

    @IBOutlet private var registrationButtonTopConstraint: NSLayoutConstraint?
    private var sizePreset: SizePreset = .default

    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            registrationButtonTopConstraint?.constant = 25.0
            sizePreset = .superCompact
        case .medium:
            registrationButtonTopConstraint?.constant = 60.0
            sizePreset = .compact
        case .plus, .extra:
            registrationButtonTopConstraint?.constant = 100.0
            sizePreset = .default
        case .unknown:
            fatalError()
        }

        onboardingItems = [
            OnboardingItemData(image: #imageLiteral(resourceName: "sendTel"),
                               text: "Send cryptocurrency\nby phone number",
                               additionalText: nil),
            OnboardingItemData(image: #imageLiteral(resourceName: "wallet"),
                               text: "Safe storage of\nBTC, BCH, ETH, ZAM",
                               additionalText: nil),
            OnboardingItemData(image: #imageLiteral(resourceName: "kyc"),
                               text: "Pass the verification of identity and get free ZAM tokens",
                               additionalText: nil),
            OnboardingItemData(image: #imageLiteral(resourceName: "withdrawCard"),
                               text: "Withdraw cryptocurrencies\nto your card instantly",
                               additionalText: "Coming soon"),
            OnboardingItemData(image: #imageLiteral(resourceName: "buyCrypto"),
                               text: "Buy cryptocurrencies by credit card Visa / MasterCard",
                               additionalText: "Coming soon")
        ]

        pagesCollectionView?.register(OnboardingItemComponent.self, forCellWithReuseIdentifier: "OnboardingItemComponent")
        pagesCollectionView?.delegate = self
        pagesCollectionView?.dataSource = self
        pagesCollectionView?.backgroundColor = .clear
        pagesCollectionView?.reloadData()

        pageControl?.numberOfPages = onboardingItems.count
        pageControl?.currentPageIndicatorTintColor = .skyBlue

        registrationButton?.addTarget(self, action: #selector(registrationButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
        loginButton?.addTarget(self, action: #selector(loginButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        setupDefaultStyle()
    }

    // UICollectionView dataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return onboardingItems.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingItemComponent", for: indexPath)

        guard let cell = _cell as? OnboardingItemComponent else {
            fatalError()
        }

        cell.configure(data: onboardingItems[indexPath.section])
        cell.insets = UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 30.0)
        cell.prepare(preset: sizePreset)
        return cell
    }

    // UICollectionView delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = pagesCollectionView else {
            return
        }

        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else {
            return
        }

        pageControl?.currentPage = indexPath.section
    }

    @objc
    private func registrationButtonTouchUpInsideEvent(_ sender: Any) {
        onSignup?()
    }

    @objc
    private func loginButtonTouchUpInsideEvent(_ sender: Any) {
        onLogin?()
    }
}

/**
 Struct represents all properties needed to fill Onboarding page with data.
 */
struct OnboardingItemData {
    var image: UIImage
    var text: String
    var additionalText: String?
}
