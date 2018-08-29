//
//  CoinItemComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CoinItemComponent: RectItemComponent {

    private var currentStateIndex: Int = 0 {
        didSet {
            view.backgroundColor = statesColors[currentStateIndex]
        }
    }
    private var statesColors: [UIColor] = [.darkSlateBlue, .skyBlue]

    override var nibName: String {
        return "RectItemComponent"
    }

    override func initFromNib() {
        super.initFromNib()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureEvent(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    func select() {
        currentStateIndex = 1
    }

    func unselect() {
        currentStateIndex = 0
    }

    @objc
    private func tapGestureEvent(_ sender: UITapGestureRecognizer) {
        currentStateIndex = (currentStateIndex + 1) % statesColors.count

        onTap?()
    }
}
