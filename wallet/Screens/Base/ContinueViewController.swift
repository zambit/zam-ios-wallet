//
//  ContinueViewController.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 UIViewController providing default continue behaviour: "Round @ContinueButton moving with keyboard during it appears"
 */
class ContinueViewController: KeyboardBehaviorFollowingViewController {

    @IBOutlet var continueButton: RoundContinueButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton?.customAppearance.setEnabled(false)
    }
}
