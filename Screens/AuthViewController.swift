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
    @IBOutlet var registration_screen: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var scrollView: HorizontalScrollView!
    
    var registrationScreenActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        registrationButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        registrationButton.layer.cornerRadius = 5
        registrationButton.layer.masksToBounds = false
        //
        scrollView.pages = [welcome_screen_0, welcome_screen_1, registration_screen]
        scrollView.onPageSelected = { [weak self] page in
            if let me = self {
                me.pageControl.currentPage = page
                me.registrationScreenActive = page == me.scrollView.pages.count - 1
            }
        }
        //
        pageControl.numberOfPages = scrollView.pages.count
        
    }
    
    private func openSMSConfirmationScreen() {
        self.performSegue(withIdentifier: "to_sms_confirm", sender: self)
    }
    
    @IBAction func onPageControl(_ sender: UIPageControl) {
        self.scrollView.select(page: sender.currentPage)
    }
    @IBAction func onRegistrationButton(_ sender: Any) {
        if registrationScreenActive {
            print("perform registration and sms auth")
            self.openSMSConfirmationScreen()
        } else {
            self.scrollView.select(page: scrollView.pages.count - 1)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    }
}
