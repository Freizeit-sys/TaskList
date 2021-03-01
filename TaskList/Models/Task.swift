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
}
