//
//  Component.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class Component: UIView {

    @IBOutlet var contentView: UIView!

    var nibName: String {
        return String(describing: type(of: self))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
}
