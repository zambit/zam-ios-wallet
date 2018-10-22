//
//  InitiatedPanGestureRecognizer.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class InitiatedPanGestureRecognizer: UIPanGestureRecognizer {
    
    var initialLocation: CGPoint!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state != UIGestureRecognizer.State.began {

            super.touchesBegan(touches, with: event)
            self.state = UIGestureRecognizer.State.began
        }

        initialLocation = touches.first!.location(in: view)
    }
}
