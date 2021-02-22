//
//  UserDefaults+Extensions.swift
//  TaskList
//
//  Created by Admin on 2021/02/22.
//

import Foundation

extension UserDefaults {
    
    func setSortType(_ type: SortType?, forKey key: String) {
        set(type?.rawValue, forKey: key)
    }
    
    func getSortType(forKey key: String) -> SortType? {
        if let rawValue = object(forKey: key) as? Int {
            return SortType(rawValue: rawValue)
        }
        return nil
    }
}
