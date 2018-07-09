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
    @IBOutlet var login_screen: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var scrollView: HorizontalScrollView!
    
    // controller operation mode
    enum OperationMode {
        case login
        case tutorial
        case registration
    }
    var mode: OperationMode = .tutorial
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        registrationButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        registrationButton.layer.cornerRadius = 5
        registrationButton.layer.masksToBounds = false
        setTutorialAndRegistrationMode()
    }
    
    // switch self to tutorial screens / registration
    private func setTutorialAndRegistrationMode() {
        scrollView.pages = [welcome_screen_0, welcome_screen_1, registration_screen]
        scrollView.onPageSelected = { [weak self] page in
            if let me = self {
                me.pageControl.currentPage = page
                // reg mode if last screen (reg view)
                me.mode = page == me.scrollView.pages.count - 1 ? .registration : .tutorial
            }
        }
        //
        pageControl.numberOfPages = scrollView.pages.count
    }
    // switch self to login view
    private func setLoginMode() {
        mode = .login
        scrollView.pages = [self.login_screen]
        pageControl.numberOfPages = 0
        scrollView.onPageSelected = nil
    }
    
    private func openSMSConfirmationScreen() {
        self.performSegue(withIdentifier: "to_sms_confirm", sender: self)
    }
    
    @IBAction func onPageControl(_ sender: UIPageControl) {
        self.scrollView.select(page: sender.currentPage)
    }
    @IBAction func onRegistrationButton(_ sender: Any) {
        if mode == .login {
            setTutorialAndRegistrationMode()
        }
        if mode == .registration {
            print("perform registration and sms auth")
            self.openSMSConfirmationScreen()
        } else {
            self.scrollView.select(page: scrollView.pages.count - 1)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        setLoginMode()
    }
}
