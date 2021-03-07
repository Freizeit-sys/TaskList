//
//  User.swift
//  TaskList
//
//  Created by Admin on 2021/03/06.
//

import Foundation

struct User {
    let uid: String
    let name: String
    let email: String
    let photoURL: String
    
    init(uid: String, name: String, email: String, photoURL: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.photoURL = photoURL
    }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.photoURL = dictionary["photoURL"] as? String ?? ""
    }
}
