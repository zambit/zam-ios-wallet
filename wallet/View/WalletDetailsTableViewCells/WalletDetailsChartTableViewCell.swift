//
//  WalletDetailsChartTableViewCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol WalletDetailsChartDelegate: class {

    func walletDetailsChartIntervalSelected(_ walletDetailsChart: WalletDetailsChartTableViewCell, interval: CoinPriceChartIntervalType)
}

class WalletDetailsChartTableViewCell: UITableViewCell {

    weak var delegate: WalletDetailsChartDelegate?

    private var chartView: ChartView?
    private var buttonsStackView: UIStackView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
        setupSubviews()
    }

    private func setupStyle() {
        self.backgroundColor = .clear
    }

    private func setupSubviews() {
        self.hero.isEnabled = true

        let chartView = ChartView()
        chartView.hero.modifiers = [.fade]
        chartView.backgroundColor = .clear
        chartView.insets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 50.0)
        chartView.chartBorderColor = UIColor.skyBlue.cgColor
        chartView.chartBorderWidth = 2.0
        chartView.showAxis = true

        addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leftAnchor.constraint(equalTo: leftAnchor, constant: 18.0).isActive = true
        chartView.rightAnchor.constraint(equalTo: rightAnchor, constant: -18.0).isActive = true
        chartView.topAnchor.constraint(equalTo: topAnchor, constant: 35.0).isActive = true

        self.chartView = chartView

        let stackView = UIStackView()
        stackView.spacing = 4.0
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 15.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0).isActive = true

        for interval in CoinPriceChartIntervalType.allCases {
            let button = SelectableButton(type: .custom)
            button.hero.modifiers = [.fade]
            button.tag = interval.rawValue
            button.titleLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
            button.setTitle(interval.title, for: .normal)
            button.setTitleColor(.darkIndigo, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setImage(nil, for: .normal)
            button.setSelectedBackgroundColor(.skyBlue)
            button.backgroundColor = .white
            button.layer.cornerRadius = 5.0
            button.borderWidth = 1.0
            button.borderColor = UIColor.black.withAlphaComponent(0.1)
            button.addTarget(self, action: #selector(filterButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

            if interval.rawValue == 0 {
                button.isSelected = true
            }

            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 45.0).isActive = true

            stackView.addArrangedSubview(button)
        }

        self.buttonsStackView = stackView
    }

    func beginChartLoading() {
        chartView?.beginLoading()
    }

    func endChartLoading() {
        chartView?.endLoading()
    }

    func setupChart(points: [ChartLayer.Coordinate]) {
        guard let chartView = chartView else {
            return
        }

        chartView.setupChart(points: points)
    }

    private func deselectFilterButtons() {
        guard let buttons = buttonsStackView?.arrangedSubviews as? [UIButton] else {
            return
        }

        buttons.forEach {
            $0.isSelected = false
        }
    }

    @objc
    private func filterButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let interval = CoinPriceChartIntervalType(rawValue: sender.tag) else {
            return
        }

        if !sender.isSelected {
            deselectFilterButtons()
            sender.isSelected = true
            delegate?.walletDetailsChartIntervalSelected(self, interval: interval)
        }
    }
}
