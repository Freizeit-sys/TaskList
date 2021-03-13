//
//  CreateTaskController.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import UIKit

class CreateTaskController: UIViewController {
    
    var isEdit: Bool = false
    
    var task: Task? {
        didSet {
            guard let _task = self.task else { return }
            self.containerView.task = _task
        }
    }
    
    private var isDatePicker = false
    
    public var didSaveTask: ((Task) -> ())?
    public var didUpdateTask: ((Task) -> ())?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Did change keyboard and input form view backgournd color.
        containerView.textField.resignFirstResponder()
        containerView.textField.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        // Prevent the keyboard from being displayed when the date and time picker is displayed.
        return isDatePicker ? false : true
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
    lazy var containerView: TaskInputAccessoryView = {
        // height = contents height
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 168) // 168
        let view = TaskInputAccessoryView(frame: frame)
        view.backgroundColor = UIColor.scheme.secondaryBackground
        return view
    }()
    
    private let v = CreateTaskView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.task == nil {
            self.task = Task(title: "")
        }
        
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
        
        self.hideKeyboard(nil)
    }
    
    private func showKeyboard() {
        containerView.textField.becomeFirstResponder()
    }
    
    private func hideKeyboard(_ completion: (() -> Void)?) {
        containerView.textField.resignFirstResponder()
        
        guard let completion = completion else { return }
        completion()
    }
    
    private func reshowKeyboard() {
        self.isDatePicker = false
        
        // Required to toggle the display of the keyboard
        self.becomeFirstResponder()
        
        // Show input form
        self.containerView.alpha = 1.0
        self.showKeyboard()
    }
}

extension CreateTaskController: CreateTaskViewDelegate, TaskInputAccessoryViewDelegate {
    
    // MARK: - CreateTaskViewDelegate
    
    func didSelectDateTime(_ date: Date) {
        self.v.hideDateAndTimePicker {
            self.containerView.setSelectedDate(date)
            self.reshowKeyboard()
        }
    }
    
    func didHideDateTimePicker() {
        self.reshowKeyboard()
    }
    
    func didShowIsRepeatVc() {
        let repeatVC = RepeatController()
        repeatVC.didSetRepeat = { [weak self] `repeat` in
            self?.task?.repeat = `repeat`
        }
        
        if let _newTask = self.task {
            repeatVC.task = _newTask
        } else {
            repeatVC.task = Task(title: "", duedate: Date())
        }
                
        self.present(repeatVC, animated: true, completion: nil)
    }
    
    
    // MARK: - TaskInputAccessoryViewDelegate
    
    func didBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSave(_ task: Task) {
        if self.isEdit {
            guard let _task = self.task else { return }
            self.didUpdateTask?(_task)
        } else {
            self.task?.title = task.title
            self.task?.duedate = task.duedate
            self.task?.completed = task.completed
            
            guard let _newTask = self.task else { return }
            
            if _newTask.title != "" {
                self.didSaveTask?(_newTask)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func didShowDateTimePicker() {
        containerView.textField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) {
            self.inputAccessoryView?.alpha = 0.0
        } completion: { (finished) in
            self.isDatePicker = true
            self.v.showDateAndTimePicker()
        }
    }
}
