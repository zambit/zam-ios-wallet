//
//  Component.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class Component: UIView {

    @IBOutlet private var contentView: UIView!

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

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
}
