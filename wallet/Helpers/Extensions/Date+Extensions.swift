//
//  Date+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

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

    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }

    var unixTimestamp: Double {
        return timeIntervalSince1970
    }

    func dayNumber() -> String {
        return String(Calendar.current.component(.day, from: self))
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

    static func walletString(from date: Date) -> String {
        return "\(date.dayNumber()) \(date.monthName(ofStyle: .threeLetters)), \(date.dayName(ofStyle: .twoLetters))"
    }
}
