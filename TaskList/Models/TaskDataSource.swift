//
//  TaskDataSource.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

class TaskDataSource {
    
    private var tasks: [Task] = []
    
    // Test data
    init() {
        self.tasks.removeAll()
        for i in 0..<5 {
            let task = Task(title: "\(i): Task", duedate: Date())
            self.tasks.append(task)
        }
    }
    
    func save(_ task: Task) {
        tasks.append(task)
    }
    
    func task(at index: Int) -> Task? {
        if tasks.count > index {
            return tasks[index]
        }
        return nil
    }
    
    func count() -> Int {
        return tasks.count
    }
    
    func delete(at index: Int) {
        if tasks.count > index {
            tasks.remove(at: index)
        }
    }
}
