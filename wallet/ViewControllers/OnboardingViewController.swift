//
//  OnboardingViewController.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var onLogin: (() -> Void)?
    var onSignup: (() -> Void)?

    private var onboardingItems: [OnboardingItemData] = []

    @IBOutlet var pagesCollectionView: UICollectionView?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var registrationButton: UIButton?
    @IBOutlet var loginButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingItems = [
            OnboardingItemData(image: UIImage(),
                               title: "Item 1",
                               text: "Et harum Discription quidem rerum facilis est et expedita distinctiolorem ipsun"),
            OnboardingItemData(image: UIImage(),
                               title: "Item 2",
                               text: "Et harum Discription quidem rerum facilis est et expedita distinctiolorem ipsun")
        ]

        pagesCollectionView?.register(ExampleOnboardingItem.self, forCellWithReuseIdentifier: "ExampleOnboardingItem")
        pagesCollectionView?.delegate = self
        pagesCollectionView?.dataSource = self
        pagesCollectionView?.clipsToBounds = false
        pagesCollectionView?.backgroundColor = .clear

        pageControl?.numberOfPages = onboardingItems.count
        pagesCollectionView?.reloadData()

        setupViewControllerStyle()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleOnboardingItem", for: indexPath)

        guard let cell = _cell as? ExampleOnboardingItem else {
            fatalError()
        }

        cell.configure(data: onboardingItems[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func coll

    private func setupViewControllerStyle() {
        self.view.applyGradient(colors: [.backgroundDarker, .backgroundLighter])
    }
}

struct OnboardingItemData {
    var image: UIImage
    var title: String
    var text: String
}
