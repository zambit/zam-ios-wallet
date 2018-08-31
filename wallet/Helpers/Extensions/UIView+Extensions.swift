//
//  UIView+Extensions.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIView {

    func applyDefaultGradient(frame: CGRect) {
        self.applyGradient(colors: [.backgroundDarker, .backgroundLighter], frame: frame)
    }

    func applyDefaultGradient() {
        self.applyGradient(colors: [.backgroundDarker, .backgroundLighter])
    }

    func applyDefaultGradientHorizontally() {
        self.applyGradient(colors: [.backgroundHorizontalDarker, .backgroundHorizontalLighter], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, frame: CGRect? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame ?? bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations

        if let startPoint = startPoint, let endPoint = endPoint {
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {

    func beginLoading() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        let loadingView = UIView(frame: rect)

        loadingView.center = center
        loadingView.layer.sublayers = nil

        let animationFrame = CGRect(x: 0, y: 0, width: 20.0, height: 20.0)
        let animation = SpinningAnimationLayer(frame: animationFrame, color: .skyBlue)

        loadingView.layer.addSublayer(animation)
        loadingView.tag = 121514

        alpha = 0.5

        superview?.insertSubview(loadingView, aboveSubview: self)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    }

    func endLoading() {
        alpha = 1.0

        let loadingView = superview?.viewWithTag(121514)
        loadingView?.removeFromSuperview()
    }

}

extension UIView {

    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }

    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    func subviews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }


    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubviewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
