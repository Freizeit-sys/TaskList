//
//  Date+Extensions.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

// MARK: - TimeZone

extension TimeZone {
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

// MARK: - Locale

extension Locale {
    static let us = Locale(identifier: "en_US")
    static let japan = Locale(identifier: "ja_JP")
}

// MARK: - Date

extension Date {

    //    // World
    //    var calender: Calendar {
    //        var calendar = Calendar(identifier: .gregorian)
    //        calendar.timeZone = .current
    //        calendar.locale = .current
    //        return calendar
    //    }

    // Japan
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale = .japan
        return calendar
    }

    var year: Int {
        return self.calendar.component(.year, from: self)
    }

    var month: Int {
        return self.calendar.component(.month, from: self)
    }

    var day: Int {
        return self.calendar.component(.day, from: self)
    }

    var hour: Int {
        return self.calendar.component(.hour, from: self)
    }

    var minute: Int {
        return self.calendar.component(.minute, from: self)
    }

    var second: Int {
        return self.calendar.component(.second, from: self)
    }

    var today: Date {
        return self.calendar.startOfDay(for: self)
    }

    var zeroclock: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }

    enum SymbolType {
        case normal
        case standalone
        case veryShort
        case short
        case shortStandalone
        case veryShortStandalone
    }

    var weekIndex: Int {
        return calendar.component(.weekday, from: self) - 1
    }

    func week(_ type: SymbolType = .short, locale: Locale? = nil) -> String {
        return weeks(type, locale: locale)[weekIndex]
    }

    func weeks(_ type: SymbolType = .short, locale: Locale? = nil) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = locale ?? calendar.locale

        switch type {
        case .normal: return formatter.weekdaySymbols
        case .standalone: return formatter.standaloneWeekdaySymbols
        case .veryShort: return formatter.veryShortWeekdaySymbols
        case .short: return formatter.shortWeekdaySymbols
        case .shortStandalone: return formatter.shortStandaloneWeekdaySymbols
        case .veryShortStandalone: return formatter.veryShortWeekdaySymbols
        }
    }

    var monthIndex: Int {
        return calendar.component(.month, from: self) - 1
    }

    func monthSymbol(_ type: SymbolType = .short, locale: Locale? = nil) -> String {
        return monthSymbols(type, locale: locale)[monthIndex]
    }

    func monthSymbols(_ type: SymbolType = .short, locale: Locale? = nil) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = locale ?? calendar.locale

        switch type {
        case .normal: return formatter.monthSymbols
        case .standalone: return formatter.standaloneMonthSymbols
        case .veryShort: return formatter.veryShortMonthSymbols
        case .short: return formatter.shortMonthSymbols
        case .shortStandalone: return formatter.shortStandaloneMonthSymbols
        case .veryShortStandalone: return formatter.veryShortStandaloneMonthSymbols
        }
    }

    init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        self.init(timeIntervalSince1970: Date().fixed(year: year, month: month, day: day, hour: hour, minute: minute, second: second).timeIntervalSince1970)
    }

    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar

        var dateComponents = DateComponents()
        dateComponents.year = year ?? (calendar.component(.year, from: self))
        dateComponents.month  = month  ?? calendar.component(.month,  from: self)
        dateComponents.day    = day    ?? calendar.component(.day,    from: self)
        dateComponents.hour   = hour   ?? calendar.component(.hour,   from: self)
        dateComponents.minute = minute ?? calendar.component(.minute, from: self)
        dateComponents.second = second ?? calendar.component(.second, from: self)

        return calendar.date(from: dateComponents)!
    }

    func added(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar

        var dateComponents = DateComponents()
        dateComponents.year = (year ?? 0) + calendar.component(.year, from: self)
        dateComponents.month = (month ?? 0) + calendar.component(.month,  from: self)
        dateComponents.day = (day ?? 0) + calendar.component(.day, from: self)
        dateComponents.hour = (hour ?? 0) + calendar.component(.hour, from: self)
        dateComponents.minute = (minute ?? 0) + calendar.component(.minute, from: self)
        dateComponents.second = (second ?? 0) + calendar.component(.second, from: self)

        return calendar.date(from: dateComponents)!
    }

    func string(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = minute * 60
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        //let year = 12 * month

        let quotient: Int
        let unit: String

        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            // 一ヶ月より前はそのまま日にちを表示
            return self.string()
        }

        // month ago, year ago
        //        } else if secondsAgo < year {
        //            quotient = secondsAgo / month
        //            unit = "month"
        //        } else {
        //            quotient = secondsAgo / year
        //            unit = "year"
        //        }

        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }

    func isToday() -> Bool {
        return calendar.isDateInToday(self)
    }

    func isTommorow() -> Bool {
        return calendar.isDateInTomorrow(self)
    }

    func isYesterday() -> Bool {
        return calendar.isDateInYesterday(self)
    }

    func isWeekend() -> Bool {
        return calendar.isDateInWeekend(self)
    }

    func isMonth() -> Bool {
        return self.added(day: 1).zeroclock.month == Date().zeroclock.month
    }

    func firstDateOfMonth() -> Date {
        return fixed(day: 1, hour: 0, minute: 0, second: 0)
    }

    func lastDateOfMonth() -> Date {
        return added(month: 1).fixed(day: 0, hour: 0, minute: 0, second: 0)
    }
}
