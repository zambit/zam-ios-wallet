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
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        registrationButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        registrationButton.layer.cornerRadius = 5
        registrationButton.layer.masksToBounds = false
        //
        scrollView.alwaysBounceHorizontal = true
        scrollView.addSubview(welcome_screen_0)
        scrollView.addSubview(welcome_screen_1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = self.view.frame.width
        let height = scrollView.frame.height
        welcome_screen_0.frame = CGRect(x: 0, y: 0, width: width, height: height)
        welcome_screen_1.frame = CGRect(x: width, y: 0, width: width, height: height)
        scrollView.contentSize = CGSize(width: width * 2, height: height)
    }
    
    @IBAction func onRegistrationButton(_ sender: Any) {
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    }
}
