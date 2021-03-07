//
//  Task.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

enum Repeat: Int, Codable {
    case doseNotRepeat
    case EveryDay
    case EveryWeekOnMonth
    case EveryMonthOnTheFirstMonday
    case EveryMonthOnDay1
    case EveryYear
    case EveryWeekDayMonToFri
}

struct Task: Codable {
    var title: String
    var duedate: Date?
    var completed: Bool
    var timestamp: Date = Date()
    var `repeat`: Repeat
    
    init(title: String, duedate: Date? = nil, completed: Bool = false,`repeat`: Repeat = .doseNotRepeat) {
        self.title = title
        self.duedate = duedate
        self.completed = completed
        self.repeat = `repeat`
    }
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.completed = dictionary["completed"] as? Bool ?? false
        self.repeat = Repeat(rawValue: (dictionary["repeat"]) as! Int) ?? .doseNotRepeat
        
        let secondsFrom1970 = dictionary["duedate"] as? Double ?? 0
        self.duedate = Date(timeIntervalSince1970: secondsFrom1970)
        
        let _secondsFrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: _secondsFrom1970)
    }
}
