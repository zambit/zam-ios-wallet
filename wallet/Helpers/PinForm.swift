//
//  PinForm.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

class PinForm {

    private(set) var progress: String = ""
    private(set) var compared: String

    private var enterHandler: () -> Void
    private var deleteHandler: () -> Void
    private var completionHandler: () -> Void
    private var wrongHandler: () -> Void

    var isEnabled: Bool = true

    init(compared: String,
         enterHandler: @escaping () -> Void,
         deleteHandler: @escaping () -> Void,
         completionHandler: @escaping () -> Void,
         wrongHandler: @escaping () -> Void) {
        self.compared = compared
        self.enterHandler = enterHandler
        self.deleteHandler = deleteHandler
        self.completionHandler = completionHandler
        self.wrongHandler = wrongHandler
    }

    func enter(_ symbol: Character) {
        self.enter(String(symbol))
    }

    func enter(_ string: String) {
        guard isEnabled else {
            return
        }

        if progress.count >= compared.count {
            progress = ""
        }

        progress.append(string)

        self.enterHandler()

        guard progress.count == compared.count else {
            return
        }

        if progress != compared {
            self.wrongHandler()
        } else {
            self.completionHandler()
        }
    }

    func remove() {
        guard isEnabled else {
            return
        }

        if let _ = progress.popLast() {
            deleteHandler()
        }
    }

    func clear() {
        progress = ""
    }
}
