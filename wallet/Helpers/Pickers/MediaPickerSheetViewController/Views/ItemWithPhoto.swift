//
//  ItemWithPhoto.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

final class ItemWithPhoto: UICollectionViewCell {

    enum SelectableStyle {
        case multi
        case exclusive
    }

    // MARK: Properties

    static let identifier = String(describing: ItemWithPhoto.self)

    fileprivate let inset: CGFloat = 6

    fileprivate var imageView: UIImageView?
    fileprivate var unselectedCircle: UIView?
    fileprivate var selectedCircle: UIView?
    fileprivate var selectedPoint: UIView?

    override public func layoutSubviews() {
        super.layoutSubviews()
        custom.layoutSubviews()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }
}

extension BehaviorExtension where Base: ItemWithPhoto {

    func setup(style: Base.SelectableStyle) {
        base.backgroundColor = .clear

        switch style {
        case .exclusive:

            let imageView = setupImageView()

            let unselected: UIView = UIView()
            unselected.addSubview(imageView)
            base.backgroundView = unselected

            let selected: UIView = UIView()
            base.selectedBackgroundView = selected
        case .multi:

            let imageView = setupImageView()
            let unselectedCircle = setupUnselectedCircle()
            let selectedCircle = setupSelectedCircle()
            let selectedPoint = setupSelectedPoint()

            let unselected: UIView = UIView()
            unselected.addSubview(imageView)
            unselected.addSubview(unselectedCircle)
            base.backgroundView = unselected

            let selected: UIView = UIView()
            selected.addSubview(selectedCircle)
            selected.addSubview(selectedPoint)
            base.selectedBackgroundView = selected
        }
    }

    func set(image: UIImage?) {
        base.imageView?.image = image
    }

    func layoutSubviews() {
        base.imageView?.frame = base.contentView.frame
        base.imageView?.cornerRadius = 12

        if let unselectedCircle = base.unselectedCircle {
            updateAppearance(forCircle: unselectedCircle)
        }

        if let selectedCircle = base.selectedCircle {
            updateAppearance(forCircle: selectedCircle)
        }

        if let selectedPoint = base.selectedPoint {
            updateAppearance(forCircle: selectedPoint)
        }
    }

    private func updateAppearance(forCircle view: UIView) {
        guard let imageView = base.imageView, let unselectedCircle = base.unselectedCircle else {
            return
        }

        view.frame.size = CGSize(width: 28, height: 28)
        view.frame.origin.x = imageView.bounds.width - unselectedCircle.bounds.width - base.inset
        view.frame.origin.y = base.inset
        view.circleCorner = true
        view.shadowColor = UIColor.black.withAlphaComponent(0.4)
        view.shadowOffset = .zero
        view.shadowRadius = 4
        view.shadowOpacity = 0.2
        view.shadowPath = UIBezierPath(roundedRect: unselectedCircle.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: unselectedCircle.bounds.width / 2, height: unselectedCircle.bounds.width / 2)).cgPath
        view.shadowShouldRasterize = true
        view.shadowRasterizationScale = UIScreen.main.scale
    }

    private func updateAppearance(forPoint view: UIView) {
        guard let selectedCircle = base.selectedCircle, let unselectedCircle = base.unselectedCircle else {
            return
        }

        view.frame.size = CGSize(width: unselectedCircle.width - unselectedCircle.borderWidth * 2, height: unselectedCircle.height - unselectedCircle.borderWidth * 2)
        view.center = selectedCircle.center
        view.circleCorner = true
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.maskToBounds = true

        base.imageView = imageView
        return imageView
    }

    private func setupUnselectedCircle() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.borderWidth = 2
        view.borderColor = .white
        view.maskToBounds = false

        base.unselectedCircle = view
        return view
    }

    private func setupSelectedCircle() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.borderWidth = 2
        view.borderColor = .white
        view.maskToBounds = false

        base.selectedCircle = view
        return view
    }

    private func setupSelectedPoint() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x007AFF)

        base.selectedPoint = view
        return view
    }
}
