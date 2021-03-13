//
//  AuthenticationService.swift
//  TaskList
//
//  Created by Admin on 2021/03/04.
//

import Firebase
import GoogleSignIn

class AuthenticationService {
    
    var user: FirebaseAuth.User?

    private let db = Firestore.firestore()
    
    private var usersCollectionRef: CollectionReference {
        return db.collection("users")
    }
    
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
    
    func authenticationToFirebase(with credential: AuthCredential, completion: @escaping(User) -> Void) {
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
            
            completion(user)
        }
    }
    
    private func saveUser(_ user: User) {
        let data: [String: Any] = [
            "photoURL": user.photoURL,
            "username": user.name,
            "email": user.email,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        usersCollectionRef.document(uid).setData(data, completion: { (error) in
            if let error = error {
                print("Failed added user info to db.", error.localizedDescription)
            }
            print("Successfully added user info to db.")
        })
        
//        Database.database().reference().child("users").child(user.uid).setValue(value, withCompletionBlock: { (error, ref) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            print("Successfully saved user info to db.")
//        })
    }
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Failed fetched user info:", error.localizedDescription)
            }
            print("Successfully fetched user info to db.")
            
            guard let data = documentSnapshot?.data() else { return }
            let user = User(uid: uid, dictionary: data)
            completion(user)
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
