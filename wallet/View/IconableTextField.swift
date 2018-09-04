//
//  IconableTextField.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

protocol IconableTextFieldDelegate: class {

    func iconableTextFieldEditingChanged(_ iconableTextField: IconableTextField, currentDetailMode: IconableTextField.DetailMode)

    func iconableTextFieldOnRightDetailTapEvent(_ iconableTextField: IconableTextField)
}

extension IconableTextFieldDelegate {

    func iconableTextFieldOnRightDetailTapEvent(_ iconableTextField: IconableTextField) {}
}

class IconableTextField: UITextField {

    enum DetailMode {
        case left(detailImage: UIImage, detailImageTintColor: UIColor, imageOffset: CGFloat)
        case right(detailImage: UIImage, detailImageTintColor: UIColor, imageOffset: CGFloat)
        case empty
    }

    private var leftDetailImageView: CircleImageView?
    private var rightDetailImageView: CircleImageView?

    private var leftDetailOffsetConstraint: NSLayoutConstraint?
    private var rightDetailOffsetConstraint: NSLayoutConstraint?

    weak var iconableDelegate: IconableTextFieldDelegate?

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

            case .left(let detailImage, let color, let imageOffset):
                guard let leftDetail = leftDetailImageView else {
                    return
                }

                leftDetail.imageView?.image = detailImage
                leftDetail.imageView?.setImageColor(color: color)

                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                    [weak self] in

                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.rightDetailOffsetConstraint?.constant = 0
                    strongSelf.leftDetailOffsetConstraint?.constant = imageOffset + leftDetail.bounds.width
                    strongSelf.leftPadding = 10.0
                    strongSelf.rightPadding = 10.0

                    strongSelf.layoutIfNeeded()
                }, completion: nil)

            case .right(let detailImage, let color, let imageOffset):
                guard let rightDetail = rightDetailImageView else {
                    return
                }

                rightDetail.imageView?.image = detailImage
                rightDetail.imageView?.setImageColor(color: color)

                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                    [weak self] in

                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.leftDetailOffsetConstraint?.constant = 0
                    strongSelf.rightDetailOffsetConstraint?.constant = -1 * (imageOffset + rightDetail.bounds.width)
                    strongSelf.leftPadding = 10.0
                    strongSelf.rightPadding = 10.0

                    strongSelf.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()

        addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()

        addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
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

        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(rightDetailImageTapGestureEvent(_:)))
        rightDetailImageView?.addGestureRecognizer(rightTapGesture)

        addSubview(rightDetailImageView!)

        rightDetailImageView?.heightAnchor.constraint(equalTo: rightDetailImageView!.widthAnchor).isActive = true
        rightDetailImageView?.heightAnchor.constraint(equalToConstant: leftDetailImageSide).isActive = true
        
        rightDetailImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightDetailOffsetConstraint = rightDetailImageView?.leftAnchor.constraint(equalTo: rightAnchor, constant: 0)
        rightDetailOffsetConstraint?.isActive = true

        layoutIfNeeded()
    }

    /**
     Set text with calling callbacks
     */
    func setText(_ text: String) {
        clearsOnInsertion = true
        insertText(text)
        textFieldEditingChanged(self)
    }

    @objc
    private func rightDetailImageTapGestureEvent(_ sender: UITapGestureRecognizer) {
        iconableDelegate?.iconableTextFieldOnRightDetailTapEvent(self)
    }

    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        if (textField.text ?? "").count > 9 {
            switch detailMode {
            case .left:
                leftPadding = 50.0
                rightPadding = 10.0
            case .right:
                leftPadding = 10.0
                rightPadding = 50.0
            case .empty:
                leftPadding = 10.0
                rightPadding = 10.0
            }
        } else {
            leftPadding = 10.0
            rightPadding = 10.0
        }

        iconableDelegate?.iconableTextFieldEditingChanged(self, currentDetailMode: detailMode)
    }
}
