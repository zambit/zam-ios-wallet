//
//  IconableTextField.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class IconableTextField: UITextField {

    enum DetailMode {
        case left(detailImage: UIImage, detailImageTintColor: UIColor, imageOffset: CGFloat, placeholder: String)
        case right(detailImage: UIImage, detailImageTintColor: UIColor, imageOffset: CGFloat, placeholder: String)
        case empty
    }

    private var leftDetailImageView: CircleImageView?
    private var rightDetailImageView: CircleImageView?

    private var leftDetailOffsetConstraint: NSLayoutConstraint?
    private var rightDetailOffsetConstraint: NSLayoutConstraint?

    var leftPlaceholder: String = ""
    var rightPlaceholder: String = ""

    var leftDetailOffset: CGFloat = 0
    var rightDetailOffset: CGFloat = 0

    var leftDetailImageSide: CGFloat = 38.0
    var rightDetailImageSide: CGFloat = 16.0

    var detailMode: DetailMode = .empty {
        didSet {
            switch detailMode {
            case .empty:
                leftDetailOffsetConstraint?.constant = 0
                rightDetailOffsetConstraint?.constant = 0

            case .left(let detailImage, let color, let imageOffset, let placeholder):
                guard let leftDetail = leftDetailImageView else {
                    return
                }

                self.placeholder = placeholder

                leftDetail.imageView?.image = detailImage
                leftDetail.imageView?.setImageColor(color: color)

                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                    [weak self] in

                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.rightDetailOffsetConstraint?.constant = 0
                    strongSelf.leftDetailOffsetConstraint?.constant = imageOffset + leftDetail.bounds.width

                    strongSelf.layoutIfNeeded()
                }, completion: nil)

            case .right(let detailImage, let color, let imageOffset, let placeholder):
                guard let rightDetail = rightDetailImageView else {
                    return
                }

                self.placeholder = placeholder

                rightDetail.imageView?.image = detailImage
                rightDetail.imageView?.setImageColor(color: color)

                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                    [weak self] in

                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.leftDetailOffsetConstraint?.constant = 0
                    strongSelf.rightDetailOffsetConstraint?.constant = -1 * (imageOffset + rightDetail.bounds.width)

                    strongSelf.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }

    private func addSubviews() {
        leftDetailImageView?.removeFromSuperview()
        rightDetailImageView?.removeFromSuperview()

        leftDetailImageView = CircleImageView()
        leftDetailImageView?.backgroundColor = .white
        leftDetailImageView?.translatesAutoresizingMaskIntoConstraints = false

        addSubview(leftDetailImageView!)

        leftDetailImageView?.heightAnchor.constraint(equalTo: leftDetailImageView!.widthAnchor).isActive = true
        leftDetailImageView?.heightAnchor.constraint(equalToConstant: leftDetailImageSide).isActive = true

        leftDetailImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftDetailOffsetConstraint = leftDetailImageView?.rightAnchor.constraint(equalTo: leftAnchor, constant: 0)
        leftDetailOffsetConstraint?.isActive = true

        rightDetailImageView = CircleImageView()
        rightDetailImageView?.backgroundColor = .clear
        rightDetailImageView?.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rightDetailImageView!)

        rightDetailImageView?.heightAnchor.constraint(equalTo: rightDetailImageView!.widthAnchor).isActive = true
        rightDetailImageView?.heightAnchor.constraint(equalToConstant: leftDetailImageSide).isActive = true
        
        rightDetailImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightDetailOffsetConstraint = rightDetailImageView?.leftAnchor.constraint(equalTo: rightAnchor, constant: 0)
        rightDetailOffsetConstraint?.isActive = true

        layoutIfNeeded()
    }
}
