//
//  SizePreset.swift
//  wallet
//
//  Created by Alexander Ponomarev on 13/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum SizePreset {

    case superCompact
    case compact
    case `default`
}

protocol SizePresetable {

    func prepare(preset: SizePreset)

}
