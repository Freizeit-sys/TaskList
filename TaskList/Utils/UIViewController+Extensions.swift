//
//  UIViewController+Extensions.swift
//  TaskList
//
//  Created by Admin on 2021/02/06.
//

import UIKit

extension UIViewController {
    
    private final class StatusBar: UIView {}
}

extension UIApplication {
    
    var statusBar: UIView? {
        if #available(iOS 13.0, *) {
            
        }
    }
}
