//
//  AuthViewController.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet var welcome_screen_0: UIView!
    @IBOutlet var welcome_screen_1: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var scrollView: HorizontalScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        registrationButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        registrationButton.layer.cornerRadius = 5
        registrationButton.layer.masksToBounds = false
        //
        scrollView.pages = [welcome_screen_0, welcome_screen_1]
        scrollView.pageSelected = { [weak self] page in
            self?.pageControl.currentPage = page
        }
        //
        pageControl.numberOfPages = scrollView.pages.count
        
    }
    
    
    
    @IBAction func onPageControl(_ sender: UIPageControl) {
        self.scrollView.select(page: sender.currentPage)
    }
    @IBAction func onRegistrationButton(_ sender: Any) {
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    }
}
