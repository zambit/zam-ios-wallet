//
//  SendMoneyComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyComponent: Component, SegmentedControlComponentDelegate {

    @IBOutlet private var toLabel: UILabel?
    @IBOutlet private var segmentedControlComponent: SegmentedControlComponent?
    @IBOutlet private var recipientTextField: IconableTextField?
    @IBOutlet private var amountTextField: UITextField?
    @IBOutlet private var amountAltTextField: UITextField?
    @IBOutlet private var sendButton: UIButton?

    override func initFromNib() {
        super.initFromNib()

        segmentedControlComponent?.delegate = self

        recipientTextField?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        recipientTextField?.textAlignment = .center
        recipientTextField?.textColor = .white

    }

    override func setupStyle() {
        super.setupStyle()

        toLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        toLabel?.textColor = .darkIndigo

    }

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int, withAnimatedDuration: Float, color: UIColor) {
        print("Animation begin")
    }


    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int, color: UIColor) {
        recipientTextField?.backgroundColor = color
        print(index)
    }
    
}
