//
//  DecimalKeyboard.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol DecimalKeyboardComponentDelegate: class {

    func decimalKeyboardComponent(_ decimalKeyboardComponent: DecimalKeyboardComponent, keyWasTapped key: DecimalKeyboardComponent.Key)
}

class DecimalKeyboardComponent: Component {

    enum Key: String {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case zero = "0"
        case remove = "@remove"
        case touchId = "@touchId"
        case faceId = "@faceId"
        case empty = ""
    }

    weak var delegate: DecimalKeyboardComponentDelegate?

    @IBOutlet private var mainStackView: UIStackView?

    private var lineStackViews: [UIStackView] = []
    private var keyboardButtonEdge: CGFloat = 0.0
    private var keyboardButtonsHorizontalSpacing: CGFloat = 0.0
    private var keyboardButtonsVerticalSpacing: CGFloat = 0.0

    private(set) var detailButton: DecimalButton?

    override func initFromNib() {
        super.initFromNib()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            keyboardButtonEdge = 72.0
            keyboardButtonsHorizontalSpacing = 16.0
            keyboardButtonsVerticalSpacing = 8.0
            break
        case .extra, .extraLarge, .medium, .plus:
            keyboardButtonEdge = 72.0
            keyboardButtonsHorizontalSpacing = 32.0
            keyboardButtonsVerticalSpacing = 16.0
        case .unknown:
            break
        }

        setupKeyboard(buttonEdge: keyboardButtonEdge)
    }

    override func setupStyle() {
        super.setupStyle()
    }

    func setDetailButtonKey(_ key: Key) {
        switch key {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            detailButton?.custom.setDecimal(key.rawValue)
        case .remove:
            detailButton?.custom.setIcon(#imageLiteral(resourceName: "icDeleteKeyboard"), id: Key.remove.rawValue)
        case .touchId:
            detailButton?.custom.setIcon(#imageLiteral(resourceName: "icTouchId"), id: Key.touchId.rawValue)
        case .faceId:
            detailButton?.custom.setIcon(#imageLiteral(resourceName: "icFaceId"), id: Key.faceId.rawValue)
        case .empty:
            detailButton?.custom.setEmpty()
        }
    }

    private func setupKeyboard(buttonEdge: CGFloat) {
        mainStackView?.alignment = .center
        mainStackView?.axis = .vertical
        mainStackView?.distribution = .fillProportionally
        mainStackView?.spacing = keyboardButtonsVerticalSpacing

        let rect = CGRect(origin: .zero, size: CGSize(width: keyboardButtonEdge, height: keyboardButtonEdge))

        let one = DecimalButton(frame: rect)
            one.custom.setDecimal(Key.one.rawValue)
            one.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            one.heightAnchor.constraint(equalTo: one.widthAnchor).isActive = true
            one.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let two = DecimalButton(frame: rect)
            two.custom.setDecimal(Key.two.rawValue)
            two.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            two.heightAnchor.constraint(equalTo: two.widthAnchor).isActive = true
            two.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let three = DecimalButton(frame: rect)
            three.custom.setDecimal(Key.three.rawValue)
            three.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            three.heightAnchor.constraint(equalTo: three.widthAnchor).isActive = true
            three.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let firstLineStackView = UIStackView(arrangedSubviews: [one,two,three])
            firstLineStackView.alignment = .center
            firstLineStackView.axis = .horizontal
            firstLineStackView.distribution = .fillProportionally
            firstLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(firstLineStackView)

        let four = DecimalButton(frame: rect)
            four.custom.setDecimal(Key.four.rawValue)
            four.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            four.heightAnchor.constraint(equalTo: four.widthAnchor).isActive = true
            four.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let five = DecimalButton(frame: rect)
            five.custom.setDecimal(Key.five.rawValue)
            five.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            five.heightAnchor.constraint(equalTo: five.widthAnchor).isActive = true
            five.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let six = DecimalButton(frame: rect)
            six.custom.setDecimal(Key.six.rawValue)
            six.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            six.heightAnchor.constraint(equalTo: six.widthAnchor).isActive = true
            six.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let secondLineStackView = UIStackView(arrangedSubviews: [four,five,six])
            secondLineStackView.alignment = .center
            secondLineStackView.axis = .horizontal
            secondLineStackView.distribution = .fillProportionally
            secondLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(secondLineStackView)

        let seven = DecimalButton(frame: rect)
            seven.custom.setDecimal(Key.seven.rawValue)
            seven.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            seven.heightAnchor.constraint(equalTo: seven.widthAnchor).isActive = true
            seven.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let eight = DecimalButton(frame: rect)
            eight.custom.setDecimal(Key.eight.rawValue)
            eight.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            eight.heightAnchor.constraint(equalTo: eight.widthAnchor).isActive = true
            eight.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let nine = DecimalButton(frame: rect)
            nine.custom.setDecimal(Key.nine.rawValue)
            nine.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            nine.heightAnchor.constraint(equalTo: nine.widthAnchor).isActive = true
            nine.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let thirdLineStackView = UIStackView(arrangedSubviews: [seven,eight,nine])
            thirdLineStackView.alignment = .center
            thirdLineStackView.axis = .horizontal
            thirdLineStackView.distribution = .fillProportionally
            thirdLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(thirdLineStackView)

        let empty = DecimalButton(frame: rect)
            empty.custom.setEmpty()
            empty.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            empty.heightAnchor.constraint(equalTo: empty.widthAnchor).isActive = true
            empty.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        detailButton = empty

        let zero = DecimalButton(frame: rect)
            zero.custom.setDecimal(Key.zero.rawValue)
            zero.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            zero.heightAnchor.constraint(equalTo: zero.widthAnchor).isActive = true
            zero.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let remove = DecimalButton(frame: rect)
            remove.custom.setIcon(#imageLiteral(resourceName: "icDeleteKeyboard"), id: Key.remove.rawValue)
            remove.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            remove.heightAnchor.constraint(equalTo: remove.widthAnchor).isActive = true
            remove.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let endLineStackView = UIStackView(arrangedSubviews: [empty,zero,remove])
            endLineStackView.alignment = .center
            endLineStackView.axis = .horizontal
            endLineStackView.distribution = .fillProportionally
            endLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(endLineStackView)

        lineStackViews.forEach {
            mainStackView?.addArrangedSubview($0)
        }

        mainStackView?.sizeToFit()
    }

    @objc
    private func buttonWasTapped(_ sender: DecimalButton) {
        guard
            let id = sender.custom.id,
            let key = Key(rawValue: id) else {
            return
        }

        delegate?.decimalKeyboardComponent(self, keyWasTapped: key)
    }
}
