//
//  LargeSendButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class LargeSendButton: UIButton, CustomUI {

    private var loadingView: UIView!
    private var successView: DoneAnimationView!
    private var failureView: UIView!

    struct CustomAppearance {
        weak var parent: LargeSendButton?

        func setLoading() {
            parent?.isUserInteractionEnabled = true

            parent?.setTitle("", for: .normal)
            parent?.setImage(#imageLiteral(resourceName: "empty_icon"), for: .normal)
            parent?.loadingView.isHidden = false
        }

        func setSuccess() {
            UIView.animate(withDuration: 0.05) {
                self.parent?.backgroundColor = .white
            }
            
            parent?.loadingView.isHidden = true
            parent?.successView.isHidden = false

            parent?.successView.drawCheck(nil)
        }

        func setFailure() {
            UIView.animate(withDuration: 0.05) {
                self.parent?.backgroundColor = .white
            }
        }
    }

    var customAppearance: CustomAppearance {
        return CustomAppearance(parent: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupAnimationView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
        setupAnimationView()
    }

    private func setupStyle() {
        self.setTitle("Send", for: .normal)
        self.titleLabel?.textColor = .white
        self.titleLabel?.font = UIFont.walletFont(ofSize: 24.0, weight: .bold)

        self.backgroundColor = .paleOliveGreen

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.cornflower.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.3
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }

    private func setupAnimationView() {
        let side: CGFloat = min(bounds.width, bounds.height) / 100 * 55

        let frame = CGRect(x: (bounds.width - side) / 2,
                           y: (bounds.height - side) / 2,
                           width: side,
                           height: side)
        self.loadingView = UIView(frame: frame)
        self.loadingView.layer.sublayers = nil

        let animationFrame = CGRect(x: 0,
                                    y: 0,
                                    width: side,
                                    height: side)
        let animation = SpinningAnimationLayer(frame: animationFrame, color: .cornflower)
        self.loadingView.layer.addSublayer(animation)
        self.loadingView.isHidden = true

        self.addSubview(loadingView)

        self.successView = DoneAnimationView(frame: frame)
        self.successView.isHidden = true

        self.addSubview(successView)
    }
}
