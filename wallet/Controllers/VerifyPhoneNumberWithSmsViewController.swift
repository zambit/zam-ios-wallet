//
//  VerifyPhoneNumberWithSmsViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class VerifyPhoneNumberWithSmsViewController: UIViewController {

    var onContinue: ((String) -> Void)?

    func prepare(phone: String) {
        print(phone)
    }

}
