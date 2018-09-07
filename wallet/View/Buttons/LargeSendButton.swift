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

    enum SendState {
        case initial
        case loading
        case success
        case failure
    }

    private var loadingView: UIView!
    private var successView: CheckAnimationView!
    private var failureView: CrossAnimationView!

    struct CustomBehaviour {
        weak var parent: LargeSendButton?

        func setLoading() {
            parent?.setTitle("", for: .normal)
            parent?.setImage(#imageLiteral(resourceName: "icEmpty"), for: .normal)
            parent?.loadingView.isHidden = false

            parent?.sendState = .loading
        }

        func setSuccess() {
            UIView.animate(withDuration: 0.05) {
                self.parent?.backgroundColor = .white
            }
            
            parent?.loadingView.isHidden = true
            parent?.successView.isHidden = false

            parent?.successView.drawCheck(nil)

            parent?.sendState = .success
        }

        func setFailure() {
            UIView.animate(withDuration: 0.05) {
                self.parent?.backgroundColor = .white
            }

            parent?.loadingView.isHidden = true
            parent?.failureView.isHidden = false

            parent?.failureView.drawCross(nil)

            parent?.sendState = .failure
        }
    }

    var custom: CustomBehaviour {
        return CustomBehaviour(parent: self)
    }

    private(set) var sendState: SendState = .initial

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
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.walletFont(ofSize: 24.0, weight: .bold)

        self.backgroundColor = .paleOliveGreen

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 19.0)
        self.layer.shadowRadius = 9.0
        self.layer.shadowOpacity = 0.08
    }

    private func setupLayouts() {
        self.layer.cornerRadius = self.bounds.width / 2
    }

    private func setupAnimationView() {
        let side: CGFloat = min(bounds.width, bounds.height) / 100 * 35

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
        let animation = SpinningAnimationLayer(frame: animationFrame, color: .white, lineWidth: 4.0)
        self.loadingView.layer.addSublayer(animation)
        self.loadingView.isHidden = true
        self.loadingView.isUserInteractionEnabled = false

        self.addSubview(loadingView)

        self.successView = CheckAnimationView(frame: bounds.insetBy(dx: 20.0, dy: 20.0), strokeColor: .paleOliveGreen, lineWidth: 5.0)
        self.successView.isHidden = true
        self.successView.isUserInteractionEnabled = false

        self.addSubview(successView)

        self.failureView = CrossAnimationView(frame: bounds.insetBy(dx: 25.0, dy: 25.0), strokeColor: .pigPink, lineWidth: 5.0)
        self.failureView.isHidden = true
        self.failureView.isUserInteractionEnabled = false

        self.addSubview(failureView)
    }
}
