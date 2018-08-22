//
//  TouchIDAuthentication.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {

    let context = LAContext()

    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    func biometricType() -> BiometricType {
        guard canEvaluatePolicy() else {
            return .none
        }

        guard #available(iOS 11.0, *) else {
            return .touchID
        }

        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }

    func authenticateUser(reason: String, success: @escaping () -> Void, failure: @escaping (LAError?) -> Void) {
        guard canEvaluatePolicy() else {
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (succ, error) in
            DispatchQueue.main.async {
                if succ {
                    success()
                } else {
                    failure(error as? LAError)
                }
            }
        }
    }



}
