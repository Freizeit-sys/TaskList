//
//  CustomSegmentedControl.swift
//  TaskList
//
//  Created by Admin on 2020/11/19.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    private var buttons: [UIButton] = []
    private var titles: [String] = []
    
    convenience init(frame: CGRect, titles: [String]) {
        self.init(frame: frame)
        self.titles = titles
        self.commonInit()
    }
    
    private func commonInit() {
        
    }
    
    private func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        titles.forEach { (title) in
            print(title)
        }
    }
}
