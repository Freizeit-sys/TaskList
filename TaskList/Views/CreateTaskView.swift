//
//  CreateTaskView.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import UIKit

protocol CreateTaskViewDelegate: class {
    func didBack()
    func didSelectDateTime(_ date: Date)
    func didHideDateTimePicker()
    func didShowIsRepeatVc()
}

class CreateTaskView: UIView {
    
    weak var delegate: CreateTaskViewDelegate?
    
    private let overlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        return v
    }()
    
    private let overlayView2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        v.alpha = 0.0
        return v
    }()
    
    private let dateTimePickerView: DateTimePickerView = {
        let pickerView = DateTimePickerView()
        pickerView.backgroundColor = UIColor.scheme.background
        pickerView.layer.cornerRadius = 10
        pickerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        pickerView.layer.masksToBounds = false
        return pickerView
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let tapGesture2: UITapGestureRecognizer = {
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
        addSubview(overlayView2)
        addSubview(dateTimePickerView)
        
        overlayView.fillSuperView()
        overlayView2.fillSuperView()
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        
        dateTimePickerView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)
        dateTimePickerView.delegate = self
        
        tapGesture.addTarget(self, action: #selector(handleTapGesture))
        overlayView.addGestureRecognizer(tapGesture)
        
        tapGesture2.addTarget(self, action: #selector(handleTapGesture2))
        overlayView2.addGestureRecognizer(tapGesture2)
    }
    
    public func showDateAndTimePicker() {
        let height: CGFloat = 362
        let bottomInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        let originalFrame = self.dateTimePickerView.frame
        let y: CGFloat = originalFrame.origin.y - (height + bottomInset)
        
        // Initial state
        self.dateTimePickerView.frame = CGRect(x: 0, y: originalFrame.origin.y, width: originalFrame.width, height: height + bottomInset)
        
        // Final state
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.overlayView2.alpha = 1.0
            self.dateTimePickerView.frame = CGRect(x: 0, y: y, width: originalFrame.width, height: height + bottomInset)
        }, completion: nil)
    }
    
    public func hideDateAndTimePicker(_ completion: @escaping () -> Void) {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let originalFrame = self.dateTimePickerView.frame
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.overlayView2.alpha = 0.0
            self.dateTimePickerView.frame = CGRect(x: 0, y: screenHeight, width: originalFrame.width, height: originalFrame.height)
        } completion: { (finished) in
            completion()
        }

    }
    
    @objc
    private func handleTapGesture() {
        self.delegate?.didBack()
    }
    
    @objc
    private func handleTapGesture2() {
        self.hideDateAndTimePicker {
            self.delegate?.didHideDateTimePicker()
        }
    }
}

extension CreateTaskView: DateTimePickerViewDelegate {
    
    func didDone(_ date: Date) {
        self.delegate?.didSelectDateTime(date)
    }
    
    func didShowIsRepeatVC() {
        self.delegate?.didShowIsRepeatVc()
    }
}
