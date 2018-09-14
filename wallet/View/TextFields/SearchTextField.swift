//
//  SearchTextField.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol SearchTextFieldDelegate: class {

    func searchTextFieldEditingChanged(_ searchTextField: SearchTextField, query: String)
}

class SearchTextField: UITextField {

    weak var searchDelegate: SearchTextFieldDelegate?

    fileprivate var normalDetailImageView: UIImageView?
    fileprivate var editingDetailButton: UIButton?

    private var normalDetailRightOffsetConstraint: NSLayoutConstraint?
    private var editingDetailRightOffsetConstraint: NSLayoutConstraint?

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()

        addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)

        editingDetailButton?.addTarget(self, action: #selector(editingDetailButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()

        addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)

        editingDetailButton?.addTarget(self, action: #selector(editingDetailButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        clipsToBounds = true
    }

    private func addSubviews() {
        normalDetailImageView?.removeFromSuperview()

        leftPadding = 24.0
        rightPadding = 32.0

        normalDetailImageView = UIImageView()
        normalDetailImageView?.translatesAutoresizingMaskIntoConstraints = false
        normalDetailImageView?.image = #imageLiteral(resourceName: "icSearchBlue")
        normalDetailImageView?.tintColor = UIColor.cornflower.withAlphaComponent(0.4)

        insertSubview(normalDetailImageView!, at: 0)

        normalDetailImageView?.heightAnchor.constraint(equalTo: normalDetailImageView!.widthAnchor).isActive = true
        normalDetailImageView?.heightAnchor.constraint(equalToConstant: 16.0).isActive = true

        normalDetailImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        normalDetailRightOffsetConstraint = normalDetailImageView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -12.0)
        normalDetailRightOffsetConstraint?.isActive = true

        editingDetailButton = UIButton(type: .custom)
        editingDetailButton?.translatesAutoresizingMaskIntoConstraints = false
        editingDetailButton?.setImage(#imageLiteral(resourceName: "icCross"), for: .normal)
        editingDetailButton?.tintColor = UIColor.cornflower.withAlphaComponent(0.4)

        addSubview(editingDetailButton!)

        editingDetailButton?.heightAnchor.constraint(equalTo: editingDetailButton!.widthAnchor).isActive = true
        editingDetailButton?.heightAnchor.constraint(equalToConstant: 16.0).isActive = true

        editingDetailButton?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editingDetailRightOffsetConstraint = editingDetailButton?.rightAnchor.constraint(equalTo: rightAnchor, constant: -12.0)
        editingDetailRightOffsetConstraint?.isActive = true
        editingDetailButton?.alpha = 0.0

        layoutIfNeeded()
    }

    @objc
    private func editingDetailButtonTouchUpInsideEvent(_ sender: UIButton) {
        self.text = ""

        searchDelegate?.searchTextFieldEditingChanged(self, query: "")
    }

    @objc
    private func editingDidBegin(_ sender: SearchTextField) {
        UIView.animate(withDuration: 0.2, animations: {

            sender.normalDetailImageView?.alpha = 0.0
            sender.editingDetailButton?.alpha = 1.0
        }, completion: {
            [weak self]
            _ in

            guard let detailButton = sender.editingDetailButton else {
                return
            }

            self?.bringSubview(toFront: detailButton)
        })
    }

    @objc
    private func editingChanged(_ sender: SearchTextField) {
        searchDelegate?.searchTextFieldEditingChanged(self, query: sender.text ?? "")
    }

    @objc
    private func editingDidEnd(_ sender: SearchTextField) {
        self.resignFirstResponder()
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, animations: {

            sender.normalDetailImageView?.alpha = 1.0
            sender.editingDetailButton?.alpha = 0.0

        }, completion: {
            [weak self]
            _ in

            guard let detailImage = sender.normalDetailImageView else {
                return
            }

            self?.bringSubview(toFront: detailImage)
        })
    }
}
