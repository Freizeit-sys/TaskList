//
//  TaskList.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import Foundation

struct TaskList: Codable {
    var title: String
    var tasks: [Task]
    var selected: Bool
    
    init(title: String, tasks: [Task] = [], selected: Bool = false) {
        self.title = title
        self.tasks = tasks
        self.selected = selected
    }
}

class TaskListsDataSource {
    
    private let fileManager = FileManager.default
    private let filename = "task_lists.json"
    
    private var selectedIndex: Int = 0
    private var taskLists: [TaskList] = []
    
    // MARK: - Initializer
    
    init() {
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(filename)
        let fileExists = fileManager.fileExists(atPath: url.path)
        
        if fileExists {
            // Load task_list.json
            self.fetchTaskLists()
        } else {
            // Create task_list.json
            let taskList = TaskList(title: "Today Tasks", selected: true)
            self.taskLists.append(taskList)
            self.saveTaskLists()
        }
        
        self.setSelectedIndex()
    }
    
    // MARK: - TaskLists Methods
    
    private func isInSelection() -> Bool {
        return taskLists.map({ $0.selected }).count == 0 ? false : true
    }
    
    private func setSelectedIndex() {
        for (i, taskList) in zip(taskLists.indices, taskLists) {
            if taskList.selected {
                selectedIndex = i
            }
        }
    }
    
    // Load to tasklists
    func fetchTaskLists() {
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(filename)
        
        var jsonStr: String = ""
        
        do {
            jsonStr = try String(contentsOf: url)
        } catch {
            print("Failed to find file url: \(url)")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let data = jsonStr.data(using: .utf8)
        
        do {
            let decoded: [TaskList] = try decoder.decode([TaskList].self, from: data!)
            self.taskLists = decoded
        } catch {
            print("Failed to decode data:", error.localizedDescription)
        }
    }
    
    // Save to tasklist
    func saveTaskLists() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(filename)
        
        do {
            let data = try encoder.encode(taskLists)
            let jsonStr = String(data: data, encoding: .utf8)
            try jsonStr?.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to encode data:", error.localizedDescription)
        }
    }
    
    func getTaskLists() -> [TaskList] {
        return taskLists
    }
    
    // MARK: - TaskList Methods
    
    func selectedTaskList() -> TaskList {
        return taskLists[selectedIndex]
    }
    
    func taskList(at index: Int) -> TaskList? {
        if taskLists.count > index {
            return taskLists[index]
        }
        return nil
    }
    
    func countTaskList() -> Int {
        return taskLists.count
    }
    
    func appendTaskList(_ taskList: TaskList) {
        self.taskLists.append(taskList)
    }
    
    func removeTaskList() {
        self.taskLists.remove(at: selectedIndex)
    }
    
    func changeTaskList(at index: Int) {
        selectedIndex = index
        
        // Deselection of all task list
        for i in 0..<taskLists.count {
            taskLists[i].selected = false
        }
        
        // Select the task list to display
        taskLists[selectedIndex].selected = true
        
        // Save selection
        saveTaskLists()
    }
    
    // MARK: - Task Methods
    
    func task(at index: Int) -> Task? {
        let taskList = self.taskLists[selectedIndex]
        if taskList.tasks.count > index {
            return taskList.tasks[index]
        }
        return nil
    }
    
    func countTask() -> Int {
        let taskList = self.taskLists[selectedIndex]
        return taskList.tasks.count
    }
    
    func appendTask(_ task: Task) {
        self.taskLists[selectedIndex].tasks.append(task)
        self.saveTaskLists()
    }
    
    func removeTask(at index: Int) {
        self.taskLists[selectedIndex].tasks.remove(at: index)
        self.saveTaskLists()
    }
}
