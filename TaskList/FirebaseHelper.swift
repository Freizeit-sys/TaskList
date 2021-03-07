//
//  FirebaseHelper.swift
//  TaskList
//
//  Created by Admin on 2021/03/03.
//

import Firebase
import FirebaseFirestore
import GoogleSignIn

class FirebaseHelper: NSObject {
    
    // MARK: - Authentication
    
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    var storage: Storage!
    
    override init() {
        super.init()

        db = Firestore.firestore()
        storage = Storage.storage()
    }
    
    func didCheckLogin() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signOut() {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Cloud FireStore
    
    func fetchUser(_ completion: @escaping (User) -> Void) {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let usersRef = db.collection("users").document(uid)
            usersRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let data = document.data() else { return }
                    let user = User(uid: document.documentID, dictionary: data)
                    completion(user)
                } else {
                    print("Document does not exists")
                }
            }
        }
    }
    
    func saveUser(_ user: User, completion: @escaping(() -> Void)) {
        let data = ["profileImageURL": user.photoURL, "username": user.name, "email": user.email]
        
        db.collection("users").document(user.uid).setData(data, merge: true) { (err) in
            if let err = err {
                print("Failed to set data:", err.localizedDescription)
            } else {
                print("Successfully to set data:", data)
                completion()
            }
        }
    }
    
//    func fetchTaskLists() -> [TaskList] {
//        let taskListsRef = db.collection("taskLists")
//        taskListsRef.getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Failed to get data:", error.localizedDescription)
//            }
//
//            guard let data = snapshot?.documents else { return }
//
//        }
//    }
    
    func saveTask(_ task: Task) {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        let data = ["title": task.title, "duedate": task.duedate!, "completed": task.completed, "repeat": task.repeat, "timestamp": task.timestamp] as [String : Any]
        
        let taskListsRef = db.collection("task_lists").document(uid)
        //taskListsRef.setData(<#T##documentData: [String : Any]##[String : Any]#>, merge: <#T##Bool#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    // MARK: - Storage
}

extension FirebaseHelper: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _error = error {
            print(_error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let _error = error {
                print(_error.localizedDescription)
                return
            }
            
            // Sign in
            
        }
    }
}
