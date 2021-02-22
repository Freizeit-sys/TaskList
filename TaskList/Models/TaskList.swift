//
//  TaskList.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

struct TaskList: Codable {
    var id: Int
    var title: String
    var tasks: [Task]
    
    init(id: Int, title: String, tasks: [Task] = []) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
}
