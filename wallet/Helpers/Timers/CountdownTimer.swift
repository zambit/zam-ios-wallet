//
//  CountdownTimer.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 CountdownTimer delegate that provides some methods for receiving changing time event and completion event.
 */
public protocol CountdownTimerDelegate: class {

    func countdownTimer(_ countdownTimer: CountdownTimer, timeRemaining: CountdownTimer.Time)

    func countdownTimerWasCompleted(_ countdownTimer: CountdownTimer)
}

/**
 Timer that provides convinient interface to control and present counting down.
 */
public class CountdownTimer {

    public struct Time {
        var seconds: Int
        var minutes: Int

        init(seconds: Int) {
            self.minutes = Int(seconds) / 60 % 60
            self.seconds = Int(seconds) % 60
        }
    }

    public weak var delegate: CountdownTimerDelegate?

    private var timer: Timer = Timer()
    private let seconds: Int

    private var secondsRemaining: Int = 1

    public init(seconds: Int) {
        self.seconds = seconds
    }

    public func begin() {
        self.secondsRemaining = seconds
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(updateTimer(_:)),
                                          userInfo: nil,
                                          repeats: true)

        let time = Time(seconds: secondsRemaining)
        self.delegate?.countdownTimer(self, timeRemaining: time)
    }

    public func stop() {
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
