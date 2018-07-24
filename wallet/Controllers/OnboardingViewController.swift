//
//  OnboardingViewController.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {

    var presenter: OnboardingViewPresenter?

    @IBOutlet var pagesCollectionView: UICollectionView?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var registrationButton: UIButton?
    @IBOutlet var loginButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
    }



}
