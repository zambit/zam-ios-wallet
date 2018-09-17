//
//  FlowViewController.swift
//  wallet
//
//  Created by  me on 30/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 UIViewController that is a part of some ScreenFlow. Holds strong reference on its ScreenFlow
 */
class FlowViewController: KeyboardNotifiableViewController {

    var flow: ScreenFlow?

}

class FlowCollectionViewController: UICollectionViewController {

    var flow: ScreenFlow?
}
