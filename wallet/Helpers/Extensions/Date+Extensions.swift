//
//  Date+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Date {

    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }

    var unixTimestamp: Double {
        return timeIntervalSince1970
    }
}

// MARK: - Enums
extension Date {

    public enum DayNameStyle {
        /// 3 letter day abbreviation of day name.
        case threeLetters

        /// 2 letter day abbreviation of day name.
        case twoLetters

        /// Full day name.
        case full
    }

    public enum MonthNameStyle {
        /// 3 letter month abbreviation of month name.
        case threeLetters

        /// 1 letter month abbreviation of month name.
        case oneLetter

        /// Full month name.
        case full
    }
}

extension Date {

    var time: String {
        let dateFormatter = DateFormatter()
        let format = "HH:mm"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var day: String {
        let dateFormatter = DateFormatter()
        let format = "dd"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var year: String {
        let dateFormatter = DateFormatter()
        let format = "yyyy"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var timeZone: String {
        let dateFormatter = DateFormatter()
        let format = "ZZZZZ"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return "UTC \(dateFormatter.string(from: self))"
    }

    func dayName(ofStyle style: DayNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .twoLetters:
                return "EEEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    func monthName(ofStyle style: MonthNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var shortFormatted: String {
        let dateFormatter = DateFormatter()
        let format = "dd MMM EEEEEE"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)

        //return "\(day) \(monthName(ofStyle: .threeLetters)), \(dayName(ofStyle: .twoLetters))"
    }

    var longFormatted: String {
        let dateFormatter = DateFormatter()
        let format = "dd MMM yyyy"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)

        //return "\(day) \(monthName(ofStyle: .threeLetters)), \(year)"
    }

    var fullFormatted: String {
        return "\(dayName(ofStyle: .twoLetters)) \(monthName(ofStyle: .threeLetters)) \(day), \(year) \(timeZone)"
    }

    var fullTimeFormatted: String {
        return "\(dayName(ofStyle: .twoLetters)) \(monthName(ofStyle: .threeLetters)) \(day), \(time) \(timeZone)"
    }
}
