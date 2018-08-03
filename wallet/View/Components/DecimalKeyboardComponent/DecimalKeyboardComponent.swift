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
    }

    weak var delegate: DecimalKeyboardComponentDelegate?

    @IBOutlet private var mainStackView: UIStackView?

    private var lineStackViews: [UIStackView] = []
    private var keyboardButtonEdge: CGFloat = 0.0
    private var keyboardButtonsHorizontalSpacing: CGFloat = 0.0
    private var keyboardButtonsVerticalSpacing: CGFloat = 0.0

    override func initFromNib() {
        super.initFromNib()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            //...
            break
        case .extra, .medium:
            keyboardButtonEdge = 72.0
            keyboardButtonsHorizontalSpacing = 32.0
            keyboardButtonsVerticalSpacing = 16.0
        case .plus:
            //....
            break
        case .unknown:
            break
        }

        setupKeyboard(buttonEdge: keyboardButtonEdge)
    }

    override func setupStyle() {
        super.setupStyle()
    }

    private func setupKeyboard(buttonEdge: CGFloat) {
        mainStackView?.alignment = .fill
        mainStackView?.distribution = .equalSpacing
        mainStackView?.axis = .vertical
        mainStackView?.spacing = keyboardButtonsVerticalSpacing

        let rect = CGRect(origin: .zero, size: CGSize(width: keyboardButtonEdge, height: keyboardButtonEdge))

        let one = DecimalButton(frame: rect)
            one.customAppearance.setDecimal(Key.one.rawValue)
            one.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            one.heightAnchor.constraint(equalTo: one.widthAnchor).isActive = true
            one.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let two = DecimalButton(frame: rect)
            two.customAppearance.setDecimal(Key.two.rawValue)
            two.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            two.heightAnchor.constraint(equalTo: two.widthAnchor).isActive = true
            two.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let three = DecimalButton(frame: rect)
            three.customAppearance.setDecimal(Key.three.rawValue)
            three.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            three.heightAnchor.constraint(equalTo: three.widthAnchor).isActive = true
            three.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let firstLineStackView = UIStackView(arrangedSubviews: [one,two,three])
            firstLineStackView.alignment = .fill
            firstLineStackView.axis = .horizontal
            firstLineStackView.distribution = .equalSpacing
            firstLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(firstLineStackView)

        let four = DecimalButton(frame: rect)
            four.customAppearance.setDecimal(Key.four.rawValue)
            four.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            four.heightAnchor.constraint(equalTo: four.widthAnchor).isActive = true
            four.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let five = DecimalButton(frame: rect)
            five.customAppearance.setDecimal(Key.five.rawValue)
            five.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            five.heightAnchor.constraint(equalTo: five.widthAnchor).isActive = true
            five.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let six = DecimalButton(frame: rect)
            six.customAppearance.setDecimal(Key.six.rawValue)
            six.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            six.heightAnchor.constraint(equalTo: six.widthAnchor).isActive = true
            six.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let secondLineStackView = UIStackView(arrangedSubviews: [four,five,six])
            secondLineStackView.alignment = .fill
            secondLineStackView.axis = .horizontal
            secondLineStackView.distribution = .equalSpacing
            secondLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(secondLineStackView)

        let seven = DecimalButton(frame: rect)
            seven.customAppearance.setDecimal(Key.seven.rawValue)
            seven.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            seven.heightAnchor.constraint(equalTo: seven.widthAnchor).isActive = true
            seven.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let eight = DecimalButton(frame: rect)
            eight.customAppearance.setDecimal(Key.eight.rawValue)
            eight.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            eight.heightAnchor.constraint(equalTo: eight.widthAnchor).isActive = true
            eight.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let nine = DecimalButton(frame: rect)
            nine.customAppearance.setDecimal(Key.nine.rawValue)
            nine.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            nine.heightAnchor.constraint(equalTo: nine.widthAnchor).isActive = true
            nine.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let thirdLineStackView = UIStackView(arrangedSubviews: [seven,eight,nine])
            thirdLineStackView.alignment = .fill
            thirdLineStackView.axis = .horizontal
            thirdLineStackView.distribution = .equalSpacing
            thirdLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(thirdLineStackView)

        let empty = DecimalButton(frame: rect)
            empty.customAppearance.setEmpty()
            empty.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            empty.heightAnchor.constraint(equalTo: empty.widthAnchor).isActive = true

        let zero = DecimalButton(frame: rect)
            zero.customAppearance.setDecimal(Key.zero.rawValue)
            zero.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            zero.heightAnchor.constraint(equalTo: zero.widthAnchor).isActive = true
            zero.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let remove = DecimalButton(frame: rect)
            remove.customAppearance.setIcon(#imageLiteral(resourceName: "icDeleteKeyboard"), id: Key.remove.rawValue)
            remove.widthAnchor.constraint(equalToConstant: keyboardButtonEdge).isActive = true
            remove.heightAnchor.constraint(equalTo: remove.widthAnchor).isActive = true
            remove.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)

        let endLineStackView = UIStackView(arrangedSubviews: [empty,zero,remove])
            endLineStackView.alignment = .fill
            endLineStackView.axis = .horizontal
            endLineStackView.distribution = .equalSpacing
            endLineStackView.spacing = keyboardButtonsHorizontalSpacing

        lineStackViews.append(endLineStackView)

        lineStackViews.forEach {
            mainStackView?.addArrangedSubview($0)
        }
    }

    @objc
    private func buttonWasTapped(_ sender: DecimalButton) {
        guard
            let id = sender.customAppearance.id,
            let key = Key(rawValue: id) else {
            return
        }

        delegate?.decimalKeyboardComponent(self, keyWasTapped: key)
    }
}
