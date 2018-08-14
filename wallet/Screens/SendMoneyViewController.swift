//
//  SendMoneyViewController.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyViewController: UIViewController {

    @IBOutlet var segmentedControlComponent: SegmentedControlComponent?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "phoneOutgoing"), title: "Phone", selectedIcon: #imageLiteral(resourceName: "phoneOutgoingWhite"), selectedTintColor: .white, backColor: .lightblue)
        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "linkTo"), title: "Address", selectedIcon: #imageLiteral(resourceName: "linkToWhite"), selectedTintColor: .white, backColor: .paleOliveGreen)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
