//
//  CustomUIItems.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol CustomUI {

    associatedtype CustomAppearance

    var customAppearance: CustomAppearance { get }

}