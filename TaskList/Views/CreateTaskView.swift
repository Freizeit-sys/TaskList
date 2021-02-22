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
    
    private let calendarPickerView: CalendarPickerView = {
        let pickerView = CalendarPickerView()
        return pickerView
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
        addSubview(calendarPickerView)
        
        overlayView.fillSuperView()
        
//        calendarPickerView.anchor(top: <#T##NSLayoutYAxisAnchor?#>, left: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, paddingTop: <#T##CGFloat#>, paddingLeft: <#T##CGFloat#>, paddingBottom: <#T##CGFloat#>, paddingRight: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    
        tapGesture.addTarget(self, action: #selector(handleTapGesture))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture() {
        self.delegate?.didBack()
    }
}
