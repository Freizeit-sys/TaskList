//
//  AuthenticationService.swift
//  TaskList
//
//  Created by Admin on 2021/03/04.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthenticationService {
    
    var user: FirebaseAuth.User?
    
    func confirmLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func signIn() {
        registerStateListener()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private func registerStateListener() {
        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            print("Sign in state has changed.")
            self.user = user
        }
    }
    
    func authenticationToFirebase(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let firUser = authResult?.user else { return }
            
            let uid = firUser.uid
            let name = firUser.displayName ?? ""
            let email = firUser.email ?? ""
            let photoURL = firUser.photoURL?.absoluteString ?? ""
            
            let user = User(uid: uid, name: name, email: email, photoURL: photoURL)
            self.saveUser(user)
        }
    }
    
    private func saveUser(_ user: User) {
        let value: [String: Any] = [
            "photoURL": user.photoURL,
            "username": user.name,
            "email": user.email,
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp()
        ]
        
        Database.database().reference().child("users").child(user.uid).setValue(value, withCompletionBlock: { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Successfully saved user info to db.")
        })
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            //guard let dictionary = snapshot.value as? [String: Any] else { return }
            //print(dictionary)
            print(snapshot)
        }
    }
    
    func googleSignIn(_ presentingViewController: UIViewController) {
        GIDSignIn.sharedInstance().presentingViewController = presentingViewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func googleRestorePreviousSignIn() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
}

class FirestoreTaskRepository: NSObject {
    
    var tasklists: [TaskList] = []
    
    func fetchTaskLists() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("tasklists").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                // Set tasklists
                dictionaries.forEach { (key, value) in
                    guard let dictionary = value as? [String: Any] else { return }
                    let tasklist = TaskList(id: key, dictionary: dictionary)
                    self.tasklists.append(tasklist)
                }
            } else {
                // Set initial tasklist
                self.createInitialTaskList(ref)
            }
        }
    }
    
    private func createInitialTaskList(_ ref: DatabaseReference) {
        let tasklist = TaskList(title: "My Tasks")
        self.tasklists.append(tasklist)
        
        let value = ["title": tasklist.title]
        ref.childByAutoId().setValue(value, withCompletionBlock: { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Successfully saved initial tasklist to db.")
        })
    }
    
    func addTaskList(_ taskList: TaskList) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values: [String: Any] = ["title": taskList.title, "tasks": taskList.tasks]
        Database.database().reference().child("tasklists").child(uid).childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Successfully added task list to db.")
        }
    }
    
    func deleteTaskList(at index: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("tasklists").child(uid).child(String(index))
    }
}

//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            if dictionaries.isEmpty {
//                print("1")
//                // Set initial tasklist
//                self.createInitialTaskList(ref)
//            } else {
//                print("2")
//                // Set tasklists
//                dictionaries.forEach { (key, value) in
//                    guard let dictionary = value as? [String: Any] else { return }
//                    let tasklist = TaskList(id: key, dictionary: dictionary)
//                    self.tasklists.append(tasklist)
//                }
//                // key = 0, 1, 2
////                for (key, value) in zip(dictionaries.indices, dictionaries) {
////                    let tasklist = TaskList(id: "", dictionary: value)
////                    self.tasklists.append(tasklist)
////                }
//            }
