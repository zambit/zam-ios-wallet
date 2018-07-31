//
//  AdditionalTextButton.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct AdditionalTextButtonData {

    struct TimerParameters {
        var seconds: Int
        var textInactiveSecondsIndex: String.Index
    }

    var textActive: String
    var textInactive: String
    var timerParams: TimerParameters?
}

class AdditionalTextButton: UIButton, CustomUI, CountdownTimerDelegate {

    struct CustomAppearance {
        weak var parent: AdditionalTextButton?

        func setEnabled(_ enabled: Bool) {
            parent?.isEnabled = enabled

            if !enabled {
                parent?.timer?.begin()
            }
        }
    }

    var customAppearance: CustomAppearance {
        return CustomAppearance(parent: self)
    }

    private var textActive: String = ""
    private var textInactive: String = ""

    private var timer: CountdownTimer?
    private var textInactiveTimeIndex: String.Index?

    private var countableSeconds: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    func configure(data: AdditionalTextButtonData) {
        self.textActive = data.textActive
        self.textInactive = data.textInactive

        setTitle(textActive, for: .normal)
        setTitle(textInactive, for: .disabled)

        if let timerParams = data.timerParams {
            self.timer = CountdownTimer(seconds: timerParams.seconds)
            self.timer?.delegate = self
            self.textInactiveTimeIndex = timerParams.textInactiveSecondsIndex
        }
    }

    private func setupStyle() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        self.setTitleColor(UIColor.flatBlue, for: .disabled)
        self.setTitleColor(UIColor.skyBlue, for: .normal)
    }

    func countdownTimer(_ countdownTimer: CountdownTimer, timeRemaining: CountdownTimer.Time) {
        guard let timeIndex = textInactiveTimeIndex else {
            return
        }

        var text = textInactive
        text.insert(contentsOf: "\(timeRemaining.minutes):\(timeRemaining.seconds)", at: timeIndex)


        self.setTitle(text, for: .disabled)
        self.titleLabel?.text = text
    }

    func countdownTimerWasCompleted(_ countdownTimer: CountdownTimer) {
        self.setTitle(textInactive, for: .disabled)
        customAppearance.setEnabled(true)
    }
}
