//
//  CustomTabBar.swift
//  TaskList
//
//  Created by Admin on 2021/02/07.
//

import UIKit

class CustomTabBar: UIView {
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.scheme.button
        let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    
    let createTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.scheme.primary
        button.tintColor = .white
        button.setTitle("Create Task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.layer.applyMaterialShadow(elevation: 8)
        return button
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.scheme.button
        let image = UIImage(named: "options")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(menuButton)
        addSubview(createTaskButton)
        addSubview(optionsButton)
        
        createTaskButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3.0).isActive = true
        createTaskButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        createTaskButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        createTaskButton.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        createTaskButton.layer.cornerRadius = 18
        
        // iPhone X
        if #available(iOS 11.0, *) {
            
            menuButton.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
            
            optionsButton.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 24, height: 24)
            
        } else {
            
            menuButton.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
            
            optionsButton.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 24, height: 24)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden { return super.hitTest(point, with: event) }
        
        let from = point
        let to = createTaskButton.center
        
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 49 ? createTaskButton : super.hitTest(point, with: event)
    }
}
