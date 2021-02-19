//
//  CreateTaskView.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import UIKit

protocol CreateTaskViewDelegate: class {
    func didBack()
}

class CreateTaskView: UIView {
    
    weak var delegate: CreateTaskViewDelegate?
    
    private let overlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        return v
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(overlayView)
        
        overlayView.fillSuperView()
    
        tapGesture.addTarget(self, action: #selector(handleTapGesture))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture() {
        self.delegate?.didBack()
    }
}
