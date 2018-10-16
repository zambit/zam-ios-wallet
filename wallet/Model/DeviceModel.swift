//
//  DeviceModel.swift
//  wallet
//
//  Created by Alexander Ponomarev on 21/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum DeviceModel: String {
    
    case simulator     = "simulator/sandbox"

    //iPod
    case iPod1         = "iPod 1"
    case iPod2         = "iPod 2"
    case iPod3         = "iPod 3"
    case iPod4         = "iPod 4"
    case iPod5         = "iPod 5"

    //iPad
    case iPad2         = "iPad 2"
    case iPad3         = "iPad 3"
    case iPad4         = "iPad 4"
    case iPadAir       = "iPad Air "
    case iPadAir2      = "iPad Air 2"
    case iPad5         = "iPad 5" //aka iPad 2017
    case iPad6         = "iPad 6" //aka iPad 2018

    //iPad mini
    case iPadMini      = "iPad Mini"
    case iPadMini2     = "iPad Mini 2"
    case iPadMini3     = "iPad Mini 3"
    case iPadMini4     = "iPad Mini 4"

    //iPad pro
    case iPadPro9_7    = "iPad Pro 9.7\""
    case iPadPro10_5   = "iPad Pro 10.5\""
    case iPadPro12_9   = "iPad Pro 12.9\""
    case iPadPro2_12_9 = "iPad Pro 2 12.9\""

    //iPhone
    case iPhone4       = "iPhone 4"
    case iPhone4S      = "iPhone 4S"
    case iPhone5       = "iPhone 5"
    case iPhone5S      = "iPhone 5S"
    case iPhone5C      = "iPhone 5C"
    case iPhone6       = "iPhone 6"
    case iPhone6plus   = "iPhone 6 Plus"
    case iPhone6S      = "iPhone 6S"
    case iPhone6Splus  = "iPhone 6S Plus"
    case iPhoneSE      = "iPhone SE"
    case iPhone7       = "iPhone 7"
    case iPhone7plus   = "iPhone 7 Plus"
    case iPhone8       = "iPhone 8"
    case iPhone8plus   = "iPhone 8 Plus"
    case iPhoneX       = "iPhone X"
    case iPhoneXS      = "iPhone XS"
    case iPhoneXSMax   = "iPhone XS Max"
    case iPhoneXR      = "iPhone XR"

    //Apple TV
    case AppleTV       = "Apple TV"
    case AppleTV_4K    = "Apple TV 4K"
    case unrecognized  = "?unrecognized?"
}
