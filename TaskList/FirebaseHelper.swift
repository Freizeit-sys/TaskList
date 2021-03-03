//
//  FirebaseHelper.swift
//  TaskList
//
//  Created by Admin on 2021/03/03.
//

import Firebase
import FirebaseFirestore
import GoogleSignIn

struct User {
    let uid: String
    let profileImageURL: String
    let username: String
    let email: String
}

class FirebaseHelper: NSObject {
    
    // MARK: - Authentication
    
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    var storage: Storage!
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        db = Firestore.firestore()
        storage = Storage.storage()
    }
    
    func didCheckLogin() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func addStateDidChangeListener() {
        self.handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            //
        })
    }
    
    func removeStateDidChangeListener() {
        Auth.auth().removeStateDidChangeListener(handle!)
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
    
    func addUser() {
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: <#T##[String : Any]#>, completion: { (err) in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        })
    }
    
    func getCollection() {
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    // MARK: - Storage
    
    func upload() {
        
    }
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
