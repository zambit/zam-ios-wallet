//
//  ScreenFlow.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

/**
 Protocol defines basic interface for screens routing. It knows UIViewController classes of its flow's screens, so then it passes needed parameters between screens and uses NavigationController for routing between them.
 */
protocol ScreenFlow {

    init(navigationController: WalletNavigationController)

    func begin()

}
