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
        case left(detailImage: UIImage, imageOffset: CGFloat, placeholder: String)
        case right(detailImage: UIImage, imageOffset: CGFloat, placeholder: String)
        case empty
    }

    private var leftDetailImageView: UIImageView?
    private var rightDetailImageView: UIImageView?

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

            case .left(let detailImage, let imageOffset, let placeholder):
                guard let leftDetail = leftDetailImageView else {
                    return
                }

                self.placeholder = placeholder

                leftDetail.image = detailImage

                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                    [weak self] in

                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.rightDetailOffsetConstraint?.constant = 0
                    strongSelf.leftDetailOffsetConstraint?.constant = imageOffset + leftDetail.bounds.width
                }, completion: nil)

            case .right(let detailImage, let imageOffset, let placeholder):
                guard let rightDetail = rightDetailImageView else {
                    return
                }

                self.placeholder = placeholder

                rightDetail.image = detailImage

                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                    [weak self] in

                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.leftDetailOffsetConstraint?.constant = 0
                    strongSelf.rightDetailOffsetConstraint?.constant = imageOffset + rightDetail.bounds.width
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

        leftDetailImageView = UIImageView()
        leftDetailImageView?.heightAnchor.constraint(equalTo: leftDetailImageView!.widthAnchor).isActive = true
        leftDetailImageView?.heightAnchor.constraint(equalToConstant: leftDetailImageSide).isActive = true

        leftDetailOffsetConstraint = leftDetailImageView?.rightAnchor.constraint(equalTo: leftAnchor, constant: 0)
        leftDetailOffsetConstraint?.isActive = true

        rightDetailImageView = UIImageView()
        rightDetailImageView?.heightAnchor.constraint(equalTo: rightDetailImageView!.widthAnchor).isActive = true
        rightDetailImageView?.heightAnchor.constraint(equalToConstant: leftDetailImageSide).isActive = true

        rightDetailOffsetConstraint = rightDetailImageView?.leftAnchor.constraint(equalTo: rightAnchor, constant: 0)
        rightDetailOffsetConstraint?.isActive = true
    }
}
