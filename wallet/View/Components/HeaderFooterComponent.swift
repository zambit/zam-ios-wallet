//
//  HeaderFooterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class HeaderFooterComponent: UITableViewHeaderFooterView {

    @IBOutlet var view: UIView!

    var nibName: String {
        return String(describing: type(of: self))
    }

    var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            view.frame = CGRect(x: insets.left,
                                y: insets.top,
                                width: bounds.width - insets.left - insets.right,
                                height: bounds.height - insets.top - insets.bottom)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initFromNib()
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromNib()
        setupStyle()
    }

    func initFromNib() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(view)

        view.frame = CGRect(x: insets.left,
                            y: insets.top,
                            width: bounds.width - insets.left - insets.right,
                            height: bounds.height - insets.top - insets.bottom)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        detailTextLabel?.isHidden = true
    }

    func setupStyle() {
        self.view.backgroundColor = .clear
    }
}

