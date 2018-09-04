//
//  UserTelephonyInfoProvider.swift
//  wallet
//
//  Created by Alexander Ponomarev on 04/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import CoreTelephony

struct UserTelephonyInfoProvider {

    private let telephonyInfo = CTTelephonyNetworkInfo()

    var countryCode: String? {
        return telephonyInfo.subscriberCellularProvider?.isoCountryCode?.uppercased()
    }

    func getCountryCode(_ completion: @escaping (String?) -> Void) {
        if let carrier = telephonyInfo.subscriberCellularProvider {
            completion(carrier.isoCountryCode)
        } else {
            telephonyInfo.subscriberCellularProviderDidUpdateNotifier = {
                completion($0.isoCountryCode)
            }
        }
    }


}
