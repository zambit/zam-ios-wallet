//
//  PHAsset+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Photos

extension PHAsset {
    
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            return thumbnail
        }
    }
}
