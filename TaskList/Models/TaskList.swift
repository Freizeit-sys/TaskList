//
//  TaskList.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

struct TaskList: Codable {
    var id: String?
    var uid: String?
    var name: String
    var tasks: [Task]
    var createdAt: Date?
    var updatedAt: Date?
    
    init(name: String, tasks: [Task] = []) {
        self.name = name
        self.tasks = tasks
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.tasks = dictionary["tasks"] as? [Task] ?? []
        
        let createdAt = dictionary["createdAt"] as? Double ?? 0
        self.createdAt = createdAt != 0 ? Date(timeIntervalSince1970: createdAt / 1000) : nil
        
        let updatedAt = dictionary["updatedAt"] as? Double ?? 0
        self.updatedAt = updatedAt != 0 ? Date(timeIntervalSince1970: updatedAt / 1000) : nil
    }
}
