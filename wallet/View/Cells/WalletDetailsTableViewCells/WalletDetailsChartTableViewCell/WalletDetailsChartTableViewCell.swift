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

class WalletDetailsChartTableViewCell: UITableViewCell, Configurable {

    weak var delegate: WalletDetailsChartDelegate?

    private var chartView: ChartView?
    private var currentInterval: CoinPriceChartIntervalType = .day
    private var buttonsStackView: UIStackView?

    override func prepareForReuse() {
        deselectFilterButtons()
        chartView?.setupChart(points: [])
    }

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
        self.backgroundColor = .white
    }

    private func setupSubviews() {
        self.hero.isEnabled = true
        self.hero.modifiers = [.fade]

        let chartView = ChartView()
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
            button.tag = interval.rawValue + 456
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

            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 45.0).isActive = true

            stackView.addArrangedSubview(button)
        }

        self.buttonsStackView = stackView
    }

    override func beginLoading() {
        chartView?.beginLoading()
    }

    override func endLoading() {
        chartView?.endLoading()
    }

    func configure(with data: WalletDetailsChartViewData) {
        if let data = data.points {
            endLoading()
            chartView?.layoutIfNeeded()
            chartView?.setupChart(points: data)
        } else {
            beginLoading()
        }

        if let currentInterval = data.currentInterval {
            self.currentInterval = currentInterval
            selectButtonWithIndex(currentInterval.rawValue)
        }
    }

    private func selectButtonWithIndex(_ index: Int) {
        guard let button = buttonsStackView?.viewWithTag(index + 456) as? UIButton else {
            return
        }

        button.isSelected = true
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
        guard let interval = CoinPriceChartIntervalType(rawValue: sender.tag - 456) else {
            return
        }

        if !sender.isSelected {
            deselectFilterButtons()
            sender.isSelected = true
            delegate?.walletDetailsChartIntervalSelected(self, interval: interval)
        }
    }
}
