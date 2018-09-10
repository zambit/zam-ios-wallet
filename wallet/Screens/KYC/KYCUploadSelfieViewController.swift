//
//  KYCUploadSelfieViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCUploadSelfieViewController: KYCUploadDocumentViewController {

    override var descriptionTitle: String {
        return "Selfie of a customer holding the above document"
    }

    override var descriptionText: String {
        return "Make a selfie holding the ID document that you submitted. Please, look straight at the camera, do not wear sunglasses, a hat or a headband. Your selfie should be colored and the information on your document should be clearly visible."
    }

    override var documentButtonsCount: Int {
        return 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
