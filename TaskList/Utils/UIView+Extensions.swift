//
//  UIView+Extensions.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerInSuperView() {
        guard let _superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: _superview.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: _superview.centerYAnchor).isActive = true
    }
    
    func fillSuperView(_ insets: UIEdgeInsets = .zero) {
        guard let _superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: _superview.topAnchor, constant: insets.top).isActive = true
        self.leftAnchor.constraint(equalTo: _superview.leftAnchor, constant: insets.left).isActive = true
        self.rightAnchor.constraint(equalTo: _superview.rightAnchor, constant: insets.right).isActive = true
        self.bottomAnchor.constraint(equalTo: _superview.bottomAnchor, constant: insets.bottom).isActive = true
    }
}


