//
//  TaskListsDataSource.swift
//  TaskList
//
//  Created by Admin on 2021/02/22.
//

import UIKit

class TaskListsDataSource {
    
    private let fileManager = FileManager.default
    private let filename = "task_lists.json"
    
    private var selectedIndex: Int = 0
    private var taskLists: [TaskList] = []
    
    init() {
        print("init")
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(filename)
        let fileExists = fileManager.fileExists(atPath: url.path)
        
        if fileExists {
            // Load task_list.json
            self.fetchTaskLists()
            // Load selected Task List
            self.loadSelectedIndex()
        } else {
            // Create task_list.json
            let taskList = TaskList(title: "My Tasks")
            self.taskLists.append(taskList)
            self.saveTaskLists()
            
            // Save selected Task List
            self.saveSelectedIndex()
        }
    }
    
    public func getTaskLists() -> [TaskList] {
        return self.taskLists
    }
    
    private func loadSelectedIndex() {
        self.selectedIndex = UserDefaults.standard.integer(forKey: "selectedID")
    }
    
    private func saveSelectedIndex() {
        UserDefaults.standard.setValue(self.selectedIndex, forKey: "selectedID")
    }
    
    private func fetchTaskLists() {
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
    
    // MARK: - TaskList Methods
    
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
        self.saveTaskLists()
    }
    
    func removeTaskList() {
        self.taskLists.remove(at: selectedIndex)
        self.saveTaskLists()
    }
    
    func changeTaskList(at index: Int) {
        self.selectedIndex = index
        self.saveSelectedIndex()
    }
    
    func sortTaskList(_ type: SortType) {
        switch type {
        case .myOrder:
            
            let orderedAscending = taskLists.map { $0.tasks.sorted { (t1, t2) -> Bool in
                return t1.timestamp.compare(t2.timestamp) == .orderedAscending
            }}
            
            print(orderedAscending)
            
        case .date:
            
            let orderedAscending = taskLists.map { $0.tasks.sorted { (t1, t2) -> Bool in
                return t1.duedate.compare(t2.duedate) == .orderedAscending
            }}
            
            print(orderedAscending)
        }
        
        self.saveTaskLists()
    }
    
    func renameTaskList(_ title: String) {
        self.taskLists[selectedIndex].title = title
        self.saveTaskLists()
    }
    
    func selectedTaskList() -> TaskList {
        return self.taskLists[selectedIndex]
    }
    
    func isSelectedTaskList(at index: Int) -> Bool {
        return self.selectedIndex == index
    }
    
    func isInitialTaskList() -> Bool {
        return selectedIndex == 0
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
        self.taskLists[selectedIndex].tasks.insert(task, at: 0)
        self.saveTaskLists()
    }
    
    func removeTask(at index: Int) {
        self.taskLists[selectedIndex].tasks.remove(at: index)
        self.saveTaskLists()
    }
    
    func completeTask(at index: Int) {
        // Complete task
        self.taskLists[selectedIndex].tasks[index].completed = true
        
        let fromIndex = index
        let toIndex = self.countTask()
        self.moveTask(fromIndex: fromIndex, toIndex: toIndex, completed: true)
    }
    
    func uncompleteTask(at index: Int) {
        // Uncomplete task
        self.taskLists[selectedIndex].tasks[index].completed = false
        
        let fromIndex = index
        let toIndex = 0
        self.moveTask(fromIndex: fromIndex, toIndex: toIndex, completed: false)
    }
    
    func moveTask(fromIndex: Int, toIndex: Int, completed: Bool) {
        guard let fromTask = self.task(at: fromIndex) else { return }
        if completed {
            self.taskLists[selectedIndex].tasks.remove(at: fromIndex)
            self.taskLists[selectedIndex].tasks.append(fromTask)
        } else {
            self.taskLists[selectedIndex].tasks.remove(at: fromIndex)
            self.taskLists[selectedIndex].tasks.insert(fromTask, at: toIndex)
        }
    }
}
