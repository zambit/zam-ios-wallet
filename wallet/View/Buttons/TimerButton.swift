//
//  TimerButton.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct TimerButtonData {

    struct TimerParameters {
        var seconds: Int
        var textInactiveSecondsIndex: String.Index
    }

    var textActive: String
    var textInactive: String
    var timerParams: TimerParameters?

    init(textActive: String, textInactive: String? = nil, timerParams: TimerParameters? = nil) {
        self.textActive = textActive

        if let inactive = textInactive {
            self.textInactive = inactive
        } else {
            self.textInactive = textActive
        }

        self.timerParams = timerParams
    }
}

class TimerButton: UIButton, CountdownTimerDelegate {

    fileprivate var textActive: String = ""
    fileprivate var textInactive: String = ""

    fileprivate var timer: CountdownTimer?
    fileprivate var textInactiveTimeIndex: String.Index?

    private var countableSeconds: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setupStyle()
    }

    func countdownTimer(_ countdownTimer: CountdownTimer, timeRemaining: CountdownTimer.Time) {
        guard let timeIndex = textInactiveTimeIndex else {
            return
        }

        var text = textInactive
        let seconds: String = timeRemaining.seconds < 10 ? "0\(timeRemaining.seconds)" : "\(timeRemaining.seconds)"
        text.insert(contentsOf: "\(timeRemaining.minutes):\(seconds)", at: timeIndex)


        self.setTitle(text, for: .disabled)
        self.titleLabel?.text = text
    }

    func countdownTimerWasCompleted(_ countdownTimer: CountdownTimer) {
        self.setTitle(textInactive, for: .disabled)
        custom.setEnabled(true)
    }
}

extension BehaviorExtension where Base: TimerButton {

    func configure(data: TimerButtonData) {
        base.textActive = data.textActive
        base.textInactive = data.textInactive

        base.setTitle(base.textActive, for: .normal)
        base.setTitle(base.textInactive, for: .disabled)

        base.contentHorizontalAlignment = .left

        if let timerParams = data.timerParams {
            base.timer = CountdownTimer(seconds: timerParams.seconds)
            base.timer?.delegate = base
            base.textInactiveTimeIndex = timerParams.textInactiveSecondsIndex
        }
    }

    func setEnabled(_ enabled: Bool) {
        if !enabled {
            base.timer?.begin()
        }

        base.isEnabled = enabled
    }

    fileprivate func setupStyle() {
        base.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        base.setTitleColor(UIColor.flatBlue, for: .disabled)
        base.setTitleColor(UIColor.flatBlue, for: .highlighted)
        base.setTitleColor(UIColor.skyBlue, for: .normal)
    }
}
