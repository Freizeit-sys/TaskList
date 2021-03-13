//
//  FirestoreTaskRepository.swift
//  TaskList
//
//  Created by Admin on 2021/03/08.
//

import Firebase

class FirestoreConfigRepository {
    
    private let db = Firestore.firestore()
    
    private var configCollectionRef: CollectionReference {
        return db.collection("config")
    }
    
    func loadCurrentTaskListID(completion: @escaping(_ currentTaskListID: String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        configCollectionRef.document(uid).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Failed load current tasklist ID:", error.localizedDescription)
            }
            
            guard let document = documentSnapshot?.data() else { return }
            
            print("Successfully loaded current tasklist ID.")
            
            let currentTaskListID = document["currentTaskListID"] as? String ?? uid
            completion(currentTaskListID)
        }
    }
    
    func saveCurrentTaskListID(_ tasklistID: String, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fields: [String: Any] = ["currentTaskListID": tasklistID]
        configCollectionRef.document(uid).updateData(fields) { (error) in
            if let error = error {
                print("Failed updated current tasklist ID:", error.localizedDescription)
            }
            print("Succussfully updated current tasklist ID.")
            completion()
        }
    }
}

class FirestoreTaskRepository {
    
    private let db = Firestore.firestore()
    
    private var tasklistsCollectionRef: CollectionReference {
        return db.collection("tasklists")
    }
    
    private var tasksCollectionRef: CollectionReference {
        return db.collection("tasks")
    }
    
    func setInitialTaskList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "id": uid,
            "uid": uid,
            "name": "My Tasks",
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        tasklistsCollectionRef.document(uid).setData(data, merge: true) { (error) in
            if let error = error {
                print("Failed added initial tasklist:", error.localizedDescription)
            }
            print("Successfully added initial tasklist.")
        }
    }
    
    func fetchTaskLists(completion: @escaping(_ tasklists: [TaskList]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        tasklistsCollectionRef.order(by: "createdAt").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed fetched tasklists:", error.localizedDescription)
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("Set initial tasklist")
                self.setInitialTaskList()
                return
            }
            
            print("Successfully fetched tasklists.")
            
            var tasklists: [TaskList] = []
            
            for document in documents {
                let tasklistID = document.documentID
                let dictionary = document.data()
                let tasklist = TaskList(id: tasklistID, dictionary: dictionary)
                
                if tasklist.uid == uid {
                    tasklists.append(tasklist)
                }
            }
            
            completion(tasklists)
        }
    }
    
    func fetchTasks(tasklistID: String, completion: @escaping(_ tasks: [Task]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        tasksCollectionRef.order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed fetched tasks:", error.localizedDescription)
            }
            
            guard let documents = querySnapshot?.documents else { return }
            
            //print("Successfully fetched tasks.")
            
            var tasks: [Task] = []
            
            for document in documents {
                let id = document.documentID
                let dictionary = document.data()
                let task = Task(id: id, dictionary: dictionary)
                
                if task.uid == uid && task.tasklistID == tasklistID {
                    tasks.append(task)
                }
            }
            
            completion(tasks)
        }
    }
    
    func addTaskList(_ tasklist: TaskList) {
        let documentID = tasklistsCollectionRef.document().documentID
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "id": documentID,
            "uid": uid,
            "name": tasklist.name,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        tasklistsCollectionRef.document(documentID).setData(data) { (error) in
            if let error = error {
                print("Failed added tasklist:", error.localizedDescription)
            }
            print("Successfully added tasklist to db.")
        }
    }
    
    func deleteTaskList(_ tasklist: TaskList) {
        guard let tasklistID = tasklist.id else { return }
        tasklistsCollectionRef.document(tasklistID).delete { (error) in
            if let error = error {
                print("Failed deleted tasklist:", error.localizedDescription)
            }
            print("Successfully deleted tasklist to db.")
        }
    }
    
    func renameTaskList(_ tasklist: TaskList) {
        guard let tasklistID = tasklist.id else { return }
        tasklistsCollectionRef.document(tasklistID).updateData(["name": tasklist.name]) { (error) in
            if let error = error {
                print("Failed renamed tasklist:", error.localizedDescription)
            }
            print("Successfully renamed tasklist to db.")
        }
    }
    
    func sortTaskList(_ tasklist: TaskList, sortType: SortType, completion: @escaping(_ tasks: [Task]) -> Void) {
        guard let tasklistID = tasklist.id else { return }
        switch sortType {
        case .myOrder:
            sortMyOrder(tasklistID) { (sortedTasks) in
                completion(sortedTasks)
            }
        case .date:
            sortDate(tasklistID) { (sortedTasks) in
                completion(sortedTasks)
            }
        }
    }
    
    private func sortMyOrder(_ tasklistID: String, completion: @escaping(_ tasks: [Task]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        tasksCollectionRef.whereField("tasklistID", isEqualTo: tasklistID).order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed fetched tasks:", error.localizedDescription)
            }
            
            guard let documents = querySnapshot?.documents else { return }
            
            var tasks: [Task] = []
            
            for document in documents {
                let id = document.documentID
                let dictionary = document.data()
                let task = Task(id: id, dictionary: dictionary)
                
                if task.uid == uid && task.tasklistID == tasklistID {
                    tasks.append(task)
                }
            }
            
            completion(tasks)
        }
    }
    
    private func sortDate(_ tasklistID: String, completion: @escaping(_ tasks: [Task]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        tasksCollectionRef.whereField("tasklistID", isEqualTo: tasklistID).order(by: "duedate", descending: false).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed fetched tasks:", error.localizedDescription)
            }
            
            guard let documents = querySnapshot?.documents else { return }
            
            var tasks: [Task] = []
            
            for document in documents {
                let id = document.documentID
                let dictionary = document.data()
                let task = Task(id: id, dictionary: dictionary)
                
                if task.uid == uid && task.tasklistID == tasklistID {
                    tasks.append(task)
                }
            }
            
            completion(tasks)
        }
    }
    
    func addTask(_ task: Task) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let documentID = tasksCollectionRef.document().documentID
        
        var data: [String: Any] = [
            "id": documentID,
            "tasklistID": uid, // tasklistID = Task を生成する時に設定, 現在は仮で設定
            "uid": uid,
            "title": task.title,
            "completed": task.completed,
            "repeat": task.repeat.rawValue,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        if let duedate = task.duedate {
            data.updateValue(duedate, forKey: "duedate")
        }
        
        tasksCollectionRef.document(documentID).setData(data, completion: { (error) in
            if let error = error {
                print("Failed added task:", error.localizedDescription)
            }
            print("Successfully added task to db.")
        })
    }
    
    func deleteTask(_ task: Task) {
        guard let taskID = task.id else { return }
        tasksCollectionRef.document(taskID).delete { (error) in
            if let error = error {
                print("Failed deleted tasklist:", error.localizedDescription)
            }
            print("Successfully deleted tasklist to db.")
        }
    }
}
