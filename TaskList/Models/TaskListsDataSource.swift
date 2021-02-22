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
            let taskList = TaskList(title: "Today Tasks")
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
        self.saveTaskLists()
    }
    
    func removeTaskList() {
        self.taskLists.remove(at: selectedID)
        self.saveTaskLists()
    }
    
    func changeTaskList(at index: Int) {
        self.selectedID = index
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
        self.saveTaskLists()
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
