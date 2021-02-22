//
//  CreateTaskController.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import UIKit

class CreateTaskController: UIViewController {
    
    public var didSaveTask: ((Task) -> ())?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
    lazy var containerView: TaskInputAccessoryView = {
        // height = contents height
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 168) // 168
        let view = TaskInputAccessoryView(frame: frame)
        return view
    }()
    
    private let v = CreateTaskView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.delegate = self
        containerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.showKeyboard()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hideKeyboard()
    }
    
    private func showKeyboard() {
        containerView.textField.becomeFirstResponder()
    }
    
    private func hideKeyboard() {
        containerView.textField.resignFirstResponder()
    }
}

extension CreateTaskController: CreateTaskViewDelegate, TaskInputAccessoryViewDelegate {
    
    func didBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSave(_ task: Task) {
        self.didSaveTask?(task)
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSelectDueDate() {
        print("selcted duedate")
        
    }
}
