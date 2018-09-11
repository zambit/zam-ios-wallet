//
//  KYCUploadAddressDocumentViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCUploadAddressDocumentViewController: KYCUploadDocumentViewController {

    override var descriptionTitle: String {
        return "Upload document confirming address of residence"
    }

    override var descriptionText: String {
        return "Utility bill or banking statement with address, or registration in passport."
    }

    override var documentButtonsCount: Int {
        return 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

