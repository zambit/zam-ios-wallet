//
//  SegmentedControlComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

protocol SegmentedControlComponentDelegate: class {

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int, withAnimatedDuration: Float, color: UIColor)

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int, color: UIColor)

}

class SegmentedControlComponent: Component {

    weak var delegate: SegmentedControlComponentDelegate?

    private var segments: [SegmentedControlElement] = [] {
        didSet {
            reloadSegments()
            reloadBackView()
        }
    }

    private var selectedSegmentsView: UIView?
    private var mainSegmentsView: UIView?
    
    private var backView: SelectingBackView?

    private var currentIndex: Int = 0

    override func initFromNib() {
        super.initFromNib()

        mainSegmentsView = UIView(frame: bounds)
        contentView.addSubview(mainSegmentsView!)
        contentView.bringSubview(toFront: mainSegmentsView!)
        mainSegmentsView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        backView = SelectingBackView()
        contentView.addSubview(backView!)
        contentView.sendSubview(toBack: backView!)

        selectedSegmentsView = UIView(frame: bounds)
        contentView.addSubview(selectedSegmentsView!)
        contentView.bringSubview(toFront: selectedSegmentsView!)
        selectedSegmentsView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        selectedSegmentsView?.isUserInteractionEnabled = false
        selectedSegmentsView?.layer.mask = backView?.segmentMaskView.layer
        selectedSegmentsView?.clipsToBounds = true
    }

    func addSegment(icon: UIImage, title: String, selectedIcon: UIImage, selectedTintColor: UIColor, backColor: UIColor) {
        let segmentNormal = UIButton(type: .custom)
        segmentNormal.setTitle(title, for: .normal)
        segmentNormal.setImage(icon, for: .normal)
        segmentNormal.setImage(icon, for: .highlighted)
        segmentNormal.setTitleColor(.blueGrey, for: .normal)
        segmentNormal.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        segmentNormal.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        segmentNormal.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        segmentNormal.sizeToFit()
        segmentNormal.bounds = CGRect(x: 0, y: 0, width: segmentNormal.bounds.width + 16, height: segmentNormal.bounds.height)

        segmentNormal.addTarget(self, action: #selector(segmentTouchUpInsideEvent(_:)), for: .touchUpInside)

        let segmentSelected = UIButton(type: .custom)
        segmentSelected.setTitle(title, for: .normal)
        segmentSelected.setImage(selectedIcon, for: .normal)
        segmentSelected.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        segmentSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        segmentSelected.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        segmentSelected.sizeToFit()
        segmentSelected.bounds = CGRect(x: 0, y: 0, width: segmentSelected.bounds.width + 16, height: segmentSelected.bounds.height)

        let segment = SegmentedControlElement(selected: segmentSelected, normal: segmentNormal, backColor: backColor)    

        guard let selectedView = selectedSegmentsView, let mainView = mainSegmentsView  else {
            fatalError()
        }

        segment.tag = segments.count + 1
        segment.addTo(mainView: mainView, selectedView: selectedView)
        segments.append(segment)
    }

    func selectElement(withIndex index: Int) {
        guard index < segments.count, index >= 0,
            let back = backView else {
            return
        }

        delegate?.segmentedControlComponent(self, willChangeTo: index, withAnimatedDuration: 0.2, color: segments[index].backColor)

        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.001, options: .curveEaseOut, animations: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            back.center = strongSelf.segments[index].center
            back.backgroundColor = strongSelf.segments[index].backColor
        }, completion: {
            [weak self]
            _ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.currentIndex = index
            strongSelf.delegate?.segmentedControlComponent(strongSelf, currentIndexChangedTo: strongSelf.currentIndex, color: strongSelf.segments[index].backColor)
        })
    }

    private func reloadSegments() {
        for (index, element) in segments.enumerated() {
            element.center = evaluateCenterPositionForElement(withIndex: index, overallCount: segments.count)
        }
    }

    private func reloadBackView() {
        let backRect = evaluateRectOfBackView(currentIndex: currentIndex,
                                              elementsCount: segments.count,
                                              horizontalMargin: 20.0)
        backView?.frame = backRect
        backView?.backgroundColor = segments[currentIndex].backColor
    }

    private func evaluateCenterPositionForElement(withIndex index: Int, overallCount: Int) -> CGPoint {
        let distBetween = bounds.width / CGFloat(overallCount + 1)
        let x = distBetween * CGFloat(index + 1)
        let y = bounds.height / 2
        return CGPoint(x: x, y: y)
    }

    private func evaluateRectOfBackView(currentIndex: Int, elementsCount: Int, horizontalMargin: CGFloat) -> CGRect {
        let width = segments[currentIndex].width + horizontalMargin * 2
        let height = bounds.height
        let size = CGSize(width: width, height: height)

        let center = evaluateCenterPositionForElement(withIndex: currentIndex, overallCount: elementsCount)
        let origin = CGPoint(x: center.x - width / 2, y: center.y - height / 2 )

        return CGRect(origin: origin, size: size)
    }

    @objc
    private func segmentTouchUpInsideEvent(_ sender: UIButton) {
        selectElement(withIndex: sender.tag - 1)
    }
}
