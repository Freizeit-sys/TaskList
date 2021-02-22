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
    
    private var selectedID: Int = 0
    private var taskLists: [TaskList] = []
    
    init() {
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(filename)
        let fileExists = fileManager.fileExists(atPath: url.path)
        
        if fileExists {
            // Load task_list.json
            self.fetchTaskLists()
            // Load selected Task List
            self.loadSelectedID()
        } else {
            // Create task_list.json
            let taskList = TaskList(id: 0, title: "Today Tasks")
            self.taskLists.append(taskList)
            self.saveTaskLists()
            
            // Save selected Task List
            self.saveSelectedID()
        }
    }
    
    private func loadSelectedID() {
        self.selectedID = UserDefaults.standard.integer(forKey: "selectedID")
    }
    
    private func saveSelectedID() {
        UserDefaults.standard.setValue(self.selectedID, forKey: "selectedID")
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
    }
    
    func removeTaskList(id: Int) {
        self.taskLists.remove(at: id)
    }
    
    func changeTaskList(id: Int) {
        self.selectedID = id
        self.saveSelectedID()
    }
    
    func sortTaskList(_ type: SortType) {
        switch type {
        case .myOrder:
            ()
        case .date:
            ()
        }
    }
    
    func renameTaskList(_ title: String) {
        self.taskLists[selectedID].title = title
    }
    
    func selectedTaskList() -> TaskList {
        return self.taskLists[selectedID]
    }
    
    func isSelectedTaskList(at index: Int) -> Bool {
        return self.selectedID == index
    }
    
    // MARK: - Task Methods
    
    func task(at index: Int) -> Task? {
        let taskList = self.taskLists[selectedID]
        if taskList.tasks.count > index {
            return taskList.tasks[index]
        }
        return nil
    }
    
    func countTask() -> Int {
        let taskList = self.taskLists[selectedID]
        return taskList.tasks.count
    }
    
    func appendTask(_ task: Task) {
        self.taskLists[selectedID].tasks.append(task)
        self.saveTaskLists()
    }
    
    func removeTask(at index: Int) {
        self.taskLists[selectedID].tasks.remove(at: index)
        self.saveTaskLists()
    }
}

//class TaskListsDataSource {
//
//    private let fileManager = FileManager.default
//    private let filename = "task_lists.json"
//
//    private var selectedIndex: Int = 0
//    private var taskLists: [TaskList] = []
//
//    // MARK: - Initializer
//
//    init() {
//        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let url = dir.appendingPathComponent(filename)
//        let fileExists = fileManager.fileExists(atPath: url.path)
//
//        if fileExists {
//            // Load task_list.json
//            self.fetchTaskLists()
//        } else {
//            // Create task_list.json
//            let taskList = TaskList(id: 0, title: "Today Tasks", selected: true)
//            self.taskLists.append(taskList)
//            self.saveTaskLists()
//        }
//
//        self.setSelectedIndex()
//    }
//
//    // MARK: - TaskLists Methods
//
//    private func isInSelection() -> Bool {
//        return taskLists.map({ $0.selected }).count == 0 ? false : true
//    }
//
//    private func setSelectedIndex() {
//        for (i, taskList) in zip(taskLists.indices, taskLists) {
//            if taskList.selected {
//                selectedIndex = i
//            }
//        }
//    }
//
//    // Load to tasklists
//    func fetchTaskLists() {
//        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let url = dir.appendingPathComponent(filename)
//
//        var jsonStr: String = ""
//
//        do {
//            jsonStr = try String(contentsOf: url)
//        } catch {
//            print("Failed to find file url: \(url)")
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//
//        let data = jsonStr.data(using: .utf8)
//
//        do {
//            let decoded: [TaskList] = try decoder.decode([TaskList].self, from: data!)
//            self.taskLists = decoded
//        } catch {
//            print("Failed to decode data:", error.localizedDescription)
//        }
//    }
//
//    // Save to tasklist
//    func saveTaskLists() {
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//        encoder.outputFormatting = .prettyPrinted
//
//        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let url = dir.appendingPathComponent(filename)
//
//        do {
//            let data = try encoder.encode(taskLists)
//            let jsonStr = String(data: data, encoding: .utf8)
//            try jsonStr?.write(to: url, atomically: true, encoding: .utf8)
//        } catch {
//            print("Failed to encode data:", error.localizedDescription)
//        }
//    }
//
//    func getTaskLists() -> [TaskList] {
//        return taskLists
//    }
//
//    // MARK: - TaskList Methods
//
//    func selectedTaskList() -> TaskList {
//        return taskLists[selectedIndex]
//    }
//
//    func taskList(at index: Int) -> TaskList? {
//        if taskLists.count > index {
//            return taskLists[index]
//        }
//        return nil
//    }
//
//    func countTaskList() -> Int {
//        return taskLists.count
//    }
//
//    func appendTaskList(_ taskList: TaskList) {
//        self.taskLists.append(taskList)
//    }
//
//    func removeTaskList() {
//        self.taskLists.remove(at: selectedIndex)
//    }
//
//    func changeTaskList(at index: Int) {
//        selectedIndex = index
//
//        // Deselection of all task list
//        for i in 0..<taskLists.count {
//            taskLists[i].selected = false
//        }
//
//        // Select the task list to display
//        taskLists[selectedIndex].selected = true
//
//        // Save selection
//        saveTaskLists()
//    }
//
//    func sortingTaskList(_ type: SortType) {
//        switch type {
//        case .myOrder:
////            taskLists.map { $0.tasks.sorted { (t1, t2) -> Bool in
////                return t1.timestamp.compare(t2.timestamp) == .orderedAscending
////            }}
//            ()
//        case .date:
////            taskLists.map { $0.tasks.sorted { (t1, t2) -> Bool in
////                return t1.duedate.compare(t2.duedate) == .orderedAscending
////            }}
//            ()
//        }
//    }
//
//    func renameTaskListTitle(_ title: String) {
//        self.taskLists[selectedIndex].title = title
//    }
//
//    // MARK: - Task Methods
//
//    func task(at index: Int) -> Task? {
//        let taskList = self.taskLists[selectedIndex]
//        if taskList.tasks.count > index {
//            return taskList.tasks[index]
//        }
//        return nil
//    }
//
//    func countTask() -> Int {
//        let taskList = self.taskLists[selectedIndex]
//        return taskList.tasks.count
//    }
//
//    func appendTask(_ task: Task) {
//        self.taskLists[selectedIndex].tasks.append(task)
//        self.saveTaskLists()
//    }
//
//    func removeTask(at index: Int) {
//        self.taskLists[selectedIndex].tasks.remove(at: index)
//        self.saveTaskLists()
//    }
//}
