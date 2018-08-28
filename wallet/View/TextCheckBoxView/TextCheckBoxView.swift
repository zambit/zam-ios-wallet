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

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var checkBox: CheckBoxButton?
    @IBOutlet private var textLabel: UILabel?

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

        checkBox?.custom.setChecked(false)
        checkBox?.addTarget(self, action: #selector(changeCheckBoxState(_:)), for: .touchUpInside)
    }

    private func setupStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    @objc
    private func changeCheckBoxState(_ sender: Any) {
        guard let state = checkBox?.custom.isChecked else {
            return
        }

        checkBox?.custom.setChecked(!state)
    }
}
