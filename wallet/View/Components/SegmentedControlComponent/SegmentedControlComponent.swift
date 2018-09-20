//
//  SegmentedControlComponent.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

protocol SegmentedControlComponentDelegate: class {

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int)

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int)
}

extension SegmentedControlComponentDelegate {

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, willChangeTo index: Int) {}

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int) {}

}

enum SegmentedControlComponentAlignment {
    case left
    case center
    case right
}

class SegmentedControlComponent: Component {

    weak var delegate: SegmentedControlComponentDelegate?

    var alignment: SegmentedControlComponentAlignment = .left {
        didSet {
            reloadSegments()
            reloadBackView()
        }
    }

    var segmentsHorizontalSpacing: CGFloat = 10.0 {
        didSet {
            reloadSegments()
            reloadBackView()
        }
    }

    var segmentsHorizontalMargin: CGFloat = 15.0 {
        didSet {
            reloadSegments()
            reloadBackView()
        }
    }

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
        mainSegmentsView?.frame = bounds
        mainSegmentsView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        backView = SelectingBackView()
        contentView.addSubview(backView!)
        contentView.sendSubview(toBack: backView!)

        selectedSegmentsView = UIView(frame: bounds)
        contentView.addSubview(selectedSegmentsView!)
        contentView.bringSubview(toFront: selectedSegmentsView!)
        selectedSegmentsView?.frame = bounds
        selectedSegmentsView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        selectedSegmentsView?.isUserInteractionEnabled = false
        selectedSegmentsView?.layer.mask = backView?.segmentMaskView.layer
        selectedSegmentsView?.clipsToBounds = true
    }

    @discardableResult
    func addSegment(icon: UIImage, title: String, iconTintColor: UIColor, selectedTintColor: UIColor, backColor: UIColor) -> SegmentedControlElement {
        let segmentNormal = UIButton(type: .system)
        segmentNormal.setTitle(title, for: .normal)
        segmentNormal.setImage(icon, for: .normal)
        segmentNormal.tintColor = iconTintColor
        segmentNormal.setTitleColor(.blueGrey, for: .normal)
        segmentNormal.setTitleColor(UIColor.black.withAlphaComponent(0.1), for: .disabled)
        segmentNormal.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        segmentNormal.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        segmentNormal.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        segmentNormal.sizeToFit()
        segmentNormal.bounds = CGRect(x: 0, y: 0, width: segmentNormal.bounds.width + 8, height: segmentNormal.bounds.height)

        segmentNormal.addTarget(self, action: #selector(segmentTouchUpInsideEvent(_:)), for: .touchUpInside)

        let segmentSelected = UIButton(type: .system)
        segmentSelected.setTitle(title, for: .normal)
        segmentSelected.setImage(icon, for: .normal)
        segmentSelected.tintColor = selectedTintColor
        segmentSelected.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        segmentSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        segmentSelected.titleLabel?.font = UIFont.walletFont(ofSize: 16.0, weight: .medium)
        segmentSelected.sizeToFit()
        segmentSelected.bounds = CGRect(x: 0, y: 0, width: segmentSelected.bounds.width + 8, height: segmentSelected.bounds.height)

        let segment = SegmentedControlElement(selected: segmentSelected, normal: segmentNormal, backColor: backColor)    

        guard let selectedView = selectedSegmentsView, let mainView = mainSegmentsView  else {
            fatalError()
        }

        segment.tag = segments.count + 1
        segment.addTo(mainView: mainView, selectedView: selectedView)
        segments.append(segment)

        if segments.count == 1 {
            selectElement(withIndex: 0)
        }

        return segment
    }

    func selectElement(withIndex index: Int) {
        guard index < segments.count, index >= 0,
            let back = backView else {
            return
        }

        delegate?.segmentedControlComponent(self, willChangeTo: index)

        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.001, options: .curveEaseOut, animations: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            back.bounds.size.width = strongSelf.segments[index].width + strongSelf.segmentsHorizontalMargin * 2
            back.center = strongSelf.segments[index].center
            back.backgroundColor = strongSelf.segments[index].backColor
        }, completion: {
            [weak self]
            _ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.currentIndex = index
            strongSelf.delegate?.segmentedControlComponent(strongSelf, currentIndexChangedTo: strongSelf.currentIndex)
        })
    }

    private func reloadSegments() {
        let frames = evaluateFramesForElements(segments: segments, horizontalMargin: segmentsHorizontalMargin, horizontalSpace: segmentsHorizontalSpacing)

        guard segments.count == frames.count else {
            return
        }

        frames.enumerated().forEach {
            segments[$0.offset].center = CGPoint(x: $0.element.origin.x + $0.element.width / 2, y: $0.element.height / 2)
        }
    }

    private func reloadBackView() {
        guard segments.count > 0 else {
            return
        }

        let backRect = evaluateRectOfBackView(currentIndex: currentIndex,
                                              segments: segments,
                                              horizontalMargin: segmentsHorizontalMargin)
        backView?.frame = backRect
        backView?.backgroundColor = segments[currentIndex].backColor
    }

    private func evaluateFramesForElements(segments: [SegmentedControlElement], horizontalMargin: CGFloat, horizontalSpace: CGFloat) -> [CGRect] {

        guard segments.count > 0 else {
            return []
        }

        var width: CGFloat = CGFloat(segments.count) * (horizontalMargin * 2) + CGFloat(segments.count - 1) * horizontalSpace

        width = segments.reduce(width, { a, b in
            a + b.width
        })

        var offset: CGFloat

        switch alignment {
        case .center:
            offset = (self.bounds.width - width) / 2
        case .left:
            offset = 0
        case .right:
            offset = self.bounds.width - width
        }

        var frames: [CGRect] = [CGRect(x: offset, y: bounds.height / 2, width: segments[0].width + horizontalMargin * 2 , height: bounds.height)]

        for i in 1..<segments.count {
            frames.append(CGRect(x: frames[i-1].origin.x + frames[i-1].width + horizontalSpace, y: bounds.height / 2, width: segments[i].width + horizontalMargin * 2, height: bounds.height))
        }

        return frames
    }

    private func evaluateRectOfBackView(currentIndex: Int, segments: [SegmentedControlElement], horizontalMargin: CGFloat) -> CGRect {
        let width = segments[currentIndex].width + horizontalMargin * 2
        let height = bounds.height
        let size = CGSize(width: width, height: height)

        let center = segments[currentIndex].center
        let origin = CGPoint(x: center.x - width / 2, y: center.y - height / 2 )

        return CGRect(origin: origin, size: size)
    }

    @objc
    private func segmentTouchUpInsideEvent(_ sender: UIButton) {
        selectElement(withIndex: sender.tag - 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainSegmentsView?.frame = bounds
        selectedSegmentsView?.frame = bounds

        reloadSegments()
        reloadBackView()
    }
}
