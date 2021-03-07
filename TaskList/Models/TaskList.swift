//
//  TaskList.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

struct TaskList: Codable {
    var id: String?
    var title: String
    var tasks: [Task]
    
    init(id: String? = "", title: String, tasks: [Task] = []) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.tasks = []
    }
}
