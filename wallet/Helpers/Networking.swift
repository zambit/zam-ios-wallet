//
//  Networking.swift
//  wallet
//
//  Created by Alexander Ponomarev on 31/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

func performWithDelay(block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: block)
}
