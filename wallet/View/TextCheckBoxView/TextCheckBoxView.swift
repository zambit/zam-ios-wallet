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

    enum TextCheckBoxViewEvents {
        case check
    }

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var checkBox: CheckBoxButton?
    @IBOutlet private var textLabel: UILabel?

    private var checkAction: ((TextCheckBoxView) -> Void)?

    private var linkText: String?
    private var linkAction: ((String) -> Void)?

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

    func configure(text: String, tapableText: String, tapHandler: @escaping (String) -> Void) {
        let attributes: [NSAttributedStringKey: Any] = [.font: UIFont.walletFont(ofSize: 13.0, weight: .regular),
                                                        .foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let underlineString = NSMutableAttributedString(attributedString: attributedString)
        let range = (text as NSString).range(of: tapableText)
        underlineString.addAttribute(.foregroundColor, value: UIColor.fadedBlue, range: range)

        textLabel?.attributedText = underlineString
        textLabel?.isUserInteractionEnabled = true

        linkText = tapableText
        linkAction = tapHandler

        if let textLabel = textLabel {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
            textLabel.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    func addAction(_ action: @escaping (TextCheckBoxView) -> Void, for event: TextCheckBoxViewEvents) {
        switch event {
        case .check:
            self.checkAction = action
        }
    }

    var isChecked: Bool {
        return checkBox?.custom.isChecked ?? true
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
        checkAction?(self)
    }

    @objc
    func tapLabel(gesture: UITapGestureRecognizer) {
        guard let label = textLabel, let text = textLabel?.text, let link = linkText else {
            return
        }
        let range = (text as NSString).range(of: link)

        if gesture.didTapAttributedTextInLabel(label: label, inRange: range) {
            linkAction?(link)
        }
    }
}
