//
//  CountdownTimer.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

protocol CountdownTimerDelegate: class {

    func countdownTimer(_ countdownTimer: CountdownTimer, timeRemaining: CountdownTimer.Time)

    func countdownTimerWasCompleted(_ countdownTimer: CountdownTimer)
}

class CountdownTimer {

    struct Time {
        var seconds: Int
        var minutes: Int

        init(seconds: Int) {
            self.minutes = Int(seconds) / 60 % 60
            self.seconds = Int(seconds) % 60
        }
    }

    var delegate: CountdownTimerDelegate?

    private var timer: Timer = Timer()
    private let seconds: Int

    private var secondsRemaining: Int = 1

    init(seconds: Int) {
        self.seconds = seconds
    }

    func begin() {
        self.secondsRemaining = seconds
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(updateTimer(_:)),
                                          userInfo: nil,
                                          repeats: true)
    }

    func stop() {
        timer.invalidate()
        delegate?.countdownTimerWasCompleted(self)
    }

    @objc
    private func updateTimer(_ sender: Any) {
        if secondsRemaining < 1 {
            timer.invalidate()
            delegate?.countdownTimerWasCompleted(self)
        }

        secondsRemaining -= 1

        let time = Time(seconds: secondsRemaining)
        delegate?.countdownTimer(self, timeRemaining: time)
    }
}
