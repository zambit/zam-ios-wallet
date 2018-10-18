//
//  InitiatedPanGestureRecognizer.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class InitiatedPanGestureRecognizer: InstantPanGestureRecognizer {
    
    var initialTouchLocation: CGPoint!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)
    }
}
