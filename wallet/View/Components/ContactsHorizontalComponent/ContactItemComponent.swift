//
//  ContactItemComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class ContactItemComponent: RectItemComponent {

    override var nibName: String {
        return "RectItemComponent"
    }

    override func initFromNib() {
        super.initFromNib()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureEvent(_:)))
        longPressGesture.minimumPressDuration = 0.1

        view.addGestureRecognizer(longPressGesture)
    }

    @objc
    private func longPressGestureEvent(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.25, animations: {
                [weak self] in
                self?.view.transform = .init(scaleX: 0.9, y: 0.9)
                }, completion: {
                    [weak self] _ in

                    self?.onTap?()
            })
        case .ended:
            UIView.animate(withDuration: 0.25) {
                [weak self] in
                self?.view.transform = .identity
            }
        default:
            return
        }
    }
}
