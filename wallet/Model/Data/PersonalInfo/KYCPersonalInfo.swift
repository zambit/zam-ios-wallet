//
//  KYCPersonalInfo.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct KYCPersonalInfo: Equatable {

    let status: KYCStatus
    let data: KYCPersonaInfoProperties?

    init(codable: CodableKYCPersonalInfo) throws {
        guard let status = KYCStatus(rawValue: codable.status) else {
            throw KYCPersonalInfoError.kycStatusInputFormatError
        }
        self.status = status

        if let info = codable.personalData {
            self.data = try KYCPersonaInfoProperties(codable: info)
        } else {
            self.data = nil
        }
    }

    init(status: KYCStatus, data: KYCPersonaInfoProperties?) {
        self.status = status
        self.data = data
    }
}

enum KYCPersonalInfoError: Error {
    
    case kycStatusInputFormatError
}
