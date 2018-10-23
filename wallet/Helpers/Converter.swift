
//
//  Converter.swift
//  wallet
//
//  Created by Alexander Ponomarev on 23/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct Converter {

    private var api: PriceAPI?

    init(api: PriceAPI) {
        self.api = api
    }

}
