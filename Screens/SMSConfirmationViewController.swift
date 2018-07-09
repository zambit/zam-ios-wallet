//
//  SMSConfirmationViewController.swift
//  wallet
//
//  Created by  me on 09/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class SMSConfirmationViewController : UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    var seconds: Int = 11
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resendButton.isEnabled = false
        resendButton.alpha = 0.5
        onTimer() // set label text 0:00
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopTimer()
    }
    @objc func onTimer() {
        seconds -= 1
        if seconds <= 0 {
            seconds = 0
            resendButton.alpha = 1
            resendButton.isEnabled = true
            stopTimer()
        }
        timerLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
    }
    
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
