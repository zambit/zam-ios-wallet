//
//  CheckBoxTextView.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TextCheckBoxView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var checkBox: CheckBoxButton?
    @IBOutlet var textLabel: UILabel?

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

    func configure(text: String) {
        textLabel?.text = text
    }

    private func initFromNib() {
        Bundle.main.loadNibNamed("TextCheckBoxView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

}
