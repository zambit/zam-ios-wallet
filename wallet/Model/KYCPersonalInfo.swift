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
    let data: KYCPersonalInfoData?

    init(codable: CodableKYCPersonalInfo) throws {
        guard let status = KYCStatus(rawValue: codable.status) else {
            throw KYCPersonalInfoError.kycStatusResponseFormatError
        }
        self.status = status

        if let info = codable.personalData {
            self.data = try KYCPersonalInfoData(codable: info)
        } else {
            self.data = nil
        }
    }
}

enum KYCPersonalInfoError: Error {
    case kycStatusResponseFormatError
}
