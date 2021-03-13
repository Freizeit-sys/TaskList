//
//  Task.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation
import Firebase

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
    var id: String?
    var uid: String?
    var tasklistID: String?
    var title: String
    var duedate: Date?
    var completed: Bool
    var `repeat`: Repeat
    var completedAt: Date?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(title: String, duedate: Date? = nil, completed: Bool = false, repeat: Repeat = .doseNotRepeat) {
        self.title = title
        self.duedate = duedate
        self.completed = completed
        self.repeat = `repeat`
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.uid = dictionary["uid"] as? String ?? ""
        self.tasklistID = dictionary["tasklistID"] as? String ?? ""
        
        self.title = dictionary["title"] as? String ?? ""
        self.completed = dictionary["completed"] as? Bool ?? false
        
        let `repeat` = dictionary["repeat"] as? Int ?? 0
        self.repeat = Repeat(rawValue: `repeat`)!
        
        let duedate = dictionary["duedate"] as? Timestamp ?? nil
        self.duedate = duedate?.dateValue()
        
        let completedAt = dictionary["completedAt"] as? Timestamp ?? nil
        self.completedAt = completedAt?.dateValue()
        
        let createdAt = dictionary["createdAt"] as? Timestamp ?? nil
        self.createdAt = createdAt?.dateValue()
        
        let updatedAt = dictionary["updatedAt"] as? Timestamp ?? nil
        self.updatedAt = updatedAt?.dateValue()
    }
}
