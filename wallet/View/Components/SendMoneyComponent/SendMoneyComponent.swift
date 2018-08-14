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

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "phoneOutgoing"), title: "Phone", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .paleOliveGreen)
        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "linkTo"), title: "Address", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .lightblue)

    }

    override func setupStyle() {
        super.setupStyle()

        toLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        toLabel?.textColor = .darkIndigo
    }

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int, withAnimatedDuration: Float, color: UIColor) {

        switch index {
        case 0:
            recipientTextField?.detailMode = .left(detailImage: #imageLiteral(resourceName: "users"), detailImageTintColor: .paleOliveGreen, imageOffset: 16.0, placeholder: "Phone number")
            recipientTextField?.backgroundColor = color
            recipientTextField?.text = ""
        case 1:
            recipientTextField?.detailMode = .right(detailImage: #imageLiteral(resourceName: "maximize"), detailImageTintColor: .white, imageOffset: 16.0, placeholder: "Address")
            recipientTextField?.backgroundColor = color
            recipientTextField?.text = ""
        default:
            fatalError()
        }
    }

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int, color: UIColor) {
    }
    
}
