//
//  InstantPanGestureRecognizer.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

/**
 A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
 */
class InstantPanGestureRecognizer: UIPanGestureRecognizer {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
