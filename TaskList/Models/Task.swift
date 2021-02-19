//
//  Task.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

class Task {
    var title: String
    var duedate: Date
    var completed: Bool
    
    init(title: String, duedate: Date, completed: Bool = false) {
        self.title = title
        self.duedate = duedate
        self.completed = completed
    }
}
