//
//  Array+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Array {

    func subarray(from: Int, to: Int) -> Array<Element> {
        let idx1 = index(startIndex, offsetBy: Swift.max(0, from))
        let idx2 = index(startIndex, offsetBy: Swift.min(self.count, to))
        return Array(self[idx1..<idx2])
    }

}
