//
//  CustomNavigationBar.swift
//  TaskList
//
//  Created by Admin on 2021/02/06.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    private let barHeight: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.barTintColor = .rgb(red: 242, green: 246, blue: 254)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        
        var newSize = super.sizeThatFits(size)
        
        // iPhone X
        var topInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            topInset = superview?.safeAreaInsets.top ?? 0
        }
        
        newSize.height += barHeight + topInset
        
        return newSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            for subview in subviews {
                let stringFromClass = NSStringFromClass(subview.classForCoder)
                
                // Adjust the height of the bar
                if stringFromClass.contains("UIBarBackground") {
                    let topInset: CGFloat = superview?.safeAreaInsets.top ?? 0
                    subview.frame = CGRect(origin: CGPoint(x: 0, y: -topInset), size: sizeThatFits(self.bounds.size))
                }
                
                // Set the position of the subview
                if stringFromClass.contains("UINavigationBarContentView") {
                    let originalNavBarHeight: CGFloat = 44
                    let contentViewHeight: CGFloat = 60
                    let space: CGFloat = 8
                    let y = barHeight - (contentViewHeight - originalNavBarHeight) - space
                    subview.frame = CGRect(x: subview.frame.origin.x, y: y, width: subview.frame.width, height: contentViewHeight)
                }
            }
        }
    }
}
