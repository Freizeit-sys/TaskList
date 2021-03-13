////
////  FirebaseTaskRepository.swift
////  TaskList
////
////  Created by Admin on 2021/03/08.
////
//
//import Firebase
//
////    tasklists
////        list_01
////            uid
////            title
////            task_01: true
////            task_02: true
////        list_02
////        uid
////            task_01: true
////            task_02: true
////
////    tasks
////        task_01
////            title
////            duedate
////            completed
////        task_02
////            title
////            duedate
////            completed
//
//class FirebaseTaskRepository: NSObject {
//
//    private static var singleton = FirebaseTaskRepository()
//
//    static var shared: FirebaseTaskRepository {
//        return singleton
//    }
//
//    private var ref: DatabaseReference {
//        return Database.database().reference()
//    }
//
//    private var usersRef: DatabaseReference {
//        return Database.database().reference().child("users")
//    }
//
//    private var tasklistsRef: DatabaseReference {
//        return Database.database().reference().child("tasklists")
//    }
//
//    private var tasksRef: DatabaseReference {
//        return Database.database().reference().child("tasks")
//    }
//
//    private var selectedTaskListID: String?
//
//    func loadData() {
//
//    }
//
//    func fetchTaskLists(completion: @escaping([TaskList]) -> Void) {
//        var tasklists: [TaskList] = []
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        tasklistsRef.observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionaries = snapshot.value as? [String: Any] else {
//                print("Create initial tasklist to ref.")
//                return self.createInitialTaskList()
//            }
//
//            print("Successfully fetched tasklist to ref.")
//
//            dictionaries.forEach { (key, value) in
//                guard let dictionary = value as? [String: Any] else { return }
//
//                var taskList: TaskList!
//
//                if uid == dictionary["uid"] as! String {
//                    taskList = TaskList(id: key, dictionary: dictionary)
//                }
//
//                self.tasksRef.observeSingleEvent(of: .value) { (snapshot) in
//                    guard let _dictionaries = snapshot.value as? [String: Any] else { return }
//
//                    for _dictionary in _dictionaries {
//                        let task = Task(id: _dictionary.key, dictionary: _dictionary.value as! [String : Any])
//                        taskList.tasks.append(task)
//                    }
//
//                    tasklists.append(taskList)
//                    completion(tasklists)
//                }
//            }
//        }
//    }
//
//    func fetchCurrentTaskList(_ taskListID: String, completion: @escaping([Task]) -> Void) {
//        var tasks: [Task] = []
//        tasklistsRef.child(taskListID).child("tasks").observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            for dictionary in dictionaries {
//                let task = Task(id: dictionary.key, dictionary: dictionary.value as! [String : Any])
//                tasks.append(task)
//            }
//            completion(tasks)
//        }
//    }
//
////    func fetchTaskLists(completion: @escaping() -> Void) {
////        guard let uid = Auth.auth().currentUser?.uid else { return }
////        let ref1 = ref.child("tasklists")
////        ref1.observeSingleEvent(of: .value) { [self] (snapshot) in
////            guard let dictionaries = snapshot.value as? [String: Any] else {
////                print("Create initial tasklist to ref.")
////                return self.createInitialTaskList()
////            }
////
////            print("Successfully fetched tasklist to ref.")
////
////            dictionaries.forEach { (key, value) in
////                guard let dictionary = value as? [String: Any] else { return }
////                let _uid = dictionary["uid"] as! String
////
////                if _uid == uid {
////                    let taskList = TaskList(id: key, dictionary: dictionary)
////                    //self.tasklists.append(taskList)
////                }
////            }
////
////            // Set the task list to be displayed on the screen.
////            self.setCurrentTaskList()
////
////            completion()
////        }
////    }
////
//    private func createInitialTaskList() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let values: [String: Any] = ["uid": uid, "title": "My Tasks", "createdAt": ServerValue.timestamp(), "updatedAt": ServerValue.timestamp()]
//        ref.child("tasklists").child(uid).updateChildValues(values) { (error, ref) in
//            if let error = error {
//                print("Failed to created initial tasklist:", error.localizedDescription)
//            }
//
//            print("Successfully created initial tasklist to ref.")
//
//            let initialTaskList = TaskList(id: uid, title: "My Tasks")
//            //self.tasklists.append(initialTaskList)
//
//            // Set the task list to be displayed on the screen.
//            self.setCurrentTaskList()
//        }
//    }
////
////    private func fetchTasks(completion: @escaping([Task]) -> ()) {
////        var tasks: [Task] = []
////
////        let ref1 = ref.child("tasks")
////        ref1.observeSingleEvent(of: .value) { (snapshot) in
////            guard let dictionaries = snapshot.value as? [String: Any] else { return }
////
////            for dictionary in dictionaries {
////                let task = Task(id: dictionary.key, dictionary: dictionary.value as! [String : Any])
////                tasks.append(task)
////            }
////
////            completion(tasks)
////        }
////    }
////
//    private func setCurrentTaskList() {
//        //self.currentTaskList = self.tasklists.first
//    }
//
//    func countTask() -> Int {
//        return 0
//        //return currentTaskList?.tasks.count ?? 0
//    }
//
//    func addTaskList(_ taskList: TaskList) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let values: [String: Any] = [
//            "uid": uid,
//            "title": taskList.title,
//            "createdAt": ServerValue.timestamp(),
//            "updatedAt": ServerValue.timestamp()
//        ]
//
//        tasklistsRef.childByAutoId().updateChildValues(values) { (error, ref) in
//            if let error = error {
//                print("Failed to added tasklist to ref.", error.localizedDescription)
//            }
//            print("Successfully added tasklist to ref.")
//        }
//    }
//
////
////    func deleteTaskList(_ taskList: TaskList) {
////        guard let id = taskList.id else { return }
////        ref.child("tasklists").child(id).removeValue { (error, ref) in
////            if let error = error {
////                print("Failed to removed tasklist.", error.localizedDescription)
////            }
////            print("Successfully removed tasklist to ref.")
////        }
////    }
////
//    func addTask(_ task: Task, taskListID: String) {
//        var values: [String: Any] = [
//            "title": task.title,
//            "completed": task.completed,
//            "repeat": task.repeat.rawValue,
//            "createdAt": ServerValue.timestamp(),
//            "updatedAt": ServerValue.timestamp()
//        ]
//
//        if let duedate = task.duedate {
//            values.updateValue(duedate.timeIntervalSince1970, forKey: "duedate")
//        }
//
//        if let completedAt = task.completedAt{
//            values.updateValue(completedAt.timeIntervalSince1970, forKey: "completedAt")
//        }
//
//        ref.child("tasks").childByAutoId().updateChildValues(values) { (error, ref) in
//            if let error = error {
//                print("Failed added task to ref.", error.localizedDescription)
//            }
//
//            print("Successfully added task to ref.")
//
//            guard let taskID = ref.key else { return }
//            let value = [taskID: true]
//
//            self.ref.child("tasklists").child(taskListID).child("tasks").updateChildValues(value, withCompletionBlock: { (error, ref) in
//                if let error = error {
//                    print("Failed added relation to ref.", error.localizedDescription)
//                }
//                print("Successfully added relation to ref.")
//            })
//        }
//    }
////
////    func deleteTask(_ taskID: String) {
////        ref.child("tasks").child(taskID).removeValue { (error, ref) in
////            if let error = error {
////                print("Failed removed task to ref.", error.localizedDescription)
////            }
////            print("Successfully removed task to ref.")
////        }
////    }
//}
