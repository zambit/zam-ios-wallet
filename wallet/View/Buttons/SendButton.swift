//
//  LargeSendButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendButton: UIButton {

    enum SendState {
        case initial
        case loading
        case success
        case failure
    }

    fileprivate var loadingView: UIView!
    fileprivate var successView: CheckAnimationView!
    fileprivate var failureView: CrossAnimationView!

    fileprivate(set) var sendState: SendState = .initial

    override func layoutSubviews() {
        super.layoutSubviews()
        custom.setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setupStyle()
        custom.setupAnimationView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setupStyle()
        custom.setupAnimationView()
    }
}

extension BehaviorExtension where Base: SendButton {

    func setLoading() {
        base.setTitle("", for: .normal)
        base.setImage(#imageLiteral(resourceName: "icEmpty"), for: .normal)
        base.loadingView.isHidden = false

        base.sendState = .loading
    }

    func setSuccess() {
        UIView.animate(withDuration: 0.05) {
            self.base.backgroundColor = .white
        }

        base.loadingView.isHidden = true
        base.successView.isHidden = false

        base.successView.drawCheck(nil)

        base.sendState = .success
    }

    func setFailure() {
        UIView.animate(withDuration: 0.05) {
            self.base.backgroundColor = .white
        }

        base.loadingView.isHidden = true
        base.failureView.isHidden = false

        base.failureView.drawCross(nil)

        base.sendState = .failure
    }

    fileprivate func setupStyle() {
        base.setTitle("Send", for: .normal)
        base.setTitleColor(.white, for: .normal)
        base.titleLabel?.font = UIFont.walletFont(ofSize: 24.0, weight: .bold)

        base.backgroundColor = .paleOliveGreen

        base.layer.masksToBounds = false
        base.layer.shadowColor = UIColor.black.cgColor
        base.layer.shadowOffset = CGSize(width: 0.0, height: 19.0)
        base.layer.shadowRadius = 9.0
        base.layer.shadowOpacity = 0.08
    }

    fileprivate func setupLayouts() {
        base.layer.cornerRadius = base.bounds.width / 2
    }

    fileprivate func setupAnimationView() {
        let side: CGFloat = min(base.bounds.width, base.bounds.height) / 100 * 35

        let frame = CGRect(x: (base.bounds.width - side) / 2,
                           y: (base.bounds.height - side) / 2,
                           width: side,
                           height: side)
        base.loadingView = UIView(frame: frame)
        base.loadingView.layer.sublayers = nil

        let animationFrame = CGRect(x: 0,
                                    y: 0,
                                    width: side,
                                    height: side)
        let animation = SpinningAnimationLayer(frame: animationFrame, color: .white, lineWidth: 4.0)
        base.loadingView.layer.addSublayer(animation)
        base.loadingView.isHidden = true
        base.loadingView.isUserInteractionEnabled = false

        base.addSubview(base.loadingView)

        base.successView = CheckAnimationView(frame: base.bounds.insetBy(dx: 20.0, dy: 20.0), strokeColor: .paleOliveGreen, lineWidth: 5.0)
        base.successView.isHidden = true
        base.successView.isUserInteractionEnabled = false

        base.addSubview(base.successView)

        base.failureView = CrossAnimationView(frame: base.bounds.insetBy(dx: 25.0, dy: 25.0), strokeColor: .pigPink, lineWidth: 5.0)
        base.failureView.isHidden = true
        base.failureView.isUserInteractionEnabled = false

        base.addSubview(base.failureView)
    }
}
