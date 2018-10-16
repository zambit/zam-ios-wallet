//
//  PhoneVerifiableAPI.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import PromiseKit

protocol CreatePasswordProcess {

    func sendVerificationCode(to phone: String, referrerPhone: String?) -> Promise<Void>

    func verifyPhoneNumber(_ phone: String, withCode verificationCode: String) -> Promise<String>
}
