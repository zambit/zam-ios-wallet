//
//  DelayTimer.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 Timer that provides convinient way to add operations and perform it with delay.
 */
class DelayTimer {

    private var timer: Timer = Timer()
    private var operations: [(Any?, () -> Void)] = []
    private var firedOperationsStack: [(Any?, () -> Void)] = []

    let delay: Double

    init(delay: Double) {
        self.delay = delay
    }

    @discardableResult
    func addOperation(target: Any? = nil, _ block: @escaping () -> Void) -> DelayTimer {
        operations.append((target,block))
        return self
    }

    func fire() {
        self.timer.invalidate()

        self.firedOperationsStack = operations
        self.operations = []

        self.timer = Timer.scheduledTimer(timeInterval: delay,
                                          target: self,
                                          selector: #selector(performWithDelay(_:)),
                                          userInfo: nil,
                                          repeats: false)
    }

    @objc
    private func performWithDelay(_ sender: Any) {
        while firedOperationsStack.count > 0 {
            let first = firedOperationsStack.removeFirst()
            first.1()
        }
    }
}
