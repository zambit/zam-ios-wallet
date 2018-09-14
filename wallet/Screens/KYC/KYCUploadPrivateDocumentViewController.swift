//
//  KYCUploadPrivateDocumentViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCUploadPrivateDocumentViewController: KYCUploadDocumentViewController {

    override var descriptionTitle: String {
        return "Passport, or ID card, or Driving license"
    }

    override var descriptionText: String {
        return "Upload photos of your passport, ID card, or driving license as your ID document.\n\nIf you submit your passport photos, make sure it’s a reversal image. If you submit ID card or driving license, please upload 2 photos of both sides those documents. Scans and screenshots are not accepted."
    }

    override var placeholderImage: UIImage {
        return #imageLiteral(resourceName: "passport")
    }

    override var documentButtonsCount: Int {
        return 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
