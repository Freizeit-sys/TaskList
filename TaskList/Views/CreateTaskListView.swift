//
//  CreateTaskListView.swift
//  TaskList
//
//  Created by Admin on 2021/02/20.
//

import UIKit

class CreateTaskListView: UIView {
    
    var taskList: TaskList? {
        didSet {
            if let _taskList = self.taskList {
                inputFormView.inputFormType = .rename
                let title = _taskList.title
                inputFormView.textField.text = title
            } else {
                inputFormView.inputFormType = .create
            }
        }
    }
    
    var didSaveNewTaskList: ((TaskList) -> ())?
    var didSaveRenameTaskList: ((TaskList) -> ())?
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()
    
    private let inputFormView: TaskListInputFormView = {
        let inputForm = TaskListInputFormView()
        inputForm.backgroundColor = UIColor.scheme.background
        return inputForm
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let g = UITapGestureRecognizer()
        g.cancelsTouchesInView = false
        return g
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showKeyboard()
        self.setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        overlayView.frame = self.frame
        self.addSubview(overlayView)
        
        let height: CGFloat = 200
        let y: CGFloat = (frame.height / 2) - (height / 2)
        inputFormView.frame = CGRect(x: 40, y: y, width: frame.width - 80, height: height)
        inputFormView.delegate = self
        inputFormView.textField.delegate = self
        self.addSubview(inputFormView)
        
        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.overlayView.alpha = 1.0
            self.inputFormView.alpha = 1.0
        }, completion: nil)
    }
    
    private func saveNewTaskList(_ text: String) {
        let taskList = TaskList(title: text)
        self.didSaveNewTaskList?(taskList)
    }
    
    private func saveRenameTaskList(_ text: String) {
        let taskList = TaskList(title: text)
        self.didSaveRenameTaskList?(taskList)
    }
    
    private func dismiss() {
        self.hideKeyboard()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0.0
            self.inputFormView.alpha = 0.0
        } completion: { (finished) in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Keyboard
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        // Frame of view excluding the keyboard
        let remainingViewHeight = frame.height - keyboardFrame.height
        let inputFormViewFrame = inputFormView.frame
        let y = (remainingViewHeight / 2) - (inputFormViewFrame.height / 2)
        
        UIView.animate(withDuration: duration) {
            self.inputFormView.frame = CGRect(x: inputFormViewFrame.origin.x, y: y, width: inputFormViewFrame.width, height: inputFormViewFrame.height)
        }
    }
    
    @objc
    private func keyboardWillHide(_ noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let inputFormViewFrame = inputFormView.frame
        let y = (frame.height / 2) - (inputFormViewFrame.height / 2)
        
        UIView.animate(withDuration: duration) {
            self.inputFormView.frame = CGRect(x: inputFormViewFrame.origin.x, y: y, width: inputFormViewFrame.width, height: inputFormViewFrame.height)
        }
    }
    
    private func showKeyboard() {
        inputFormView.textField.becomeFirstResponder()
    }
    
    private func hideKeyboard() {
        inputFormView.textField.resignFirstResponder()
    }
    
    // MARK: UIGestureRecognizer
    
    @objc
    private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        self.dismiss()
    }
}

extension CreateTaskListView: TaskListInputFormViewDelegate {
    
    func didCreate(text: String) {
        self.saveNewTaskList(text)
        self.dismiss()
    }
    
    func didRename(text: String) {
        self.saveRenameTaskList(text)
        self.dismiss()
    }
    
    func didCancel() {
        self.dismiss()
    }
}

// MARK: - UITextFieldDelegate

extension CreateTaskListView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            guard let text = textField.text else { return false }
            self.saveNewTaskList(text)
            self.dismiss()
            return true
        }
        self.dismiss()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int = 20
        let text = textField.text! + string
        
        if text.count <= maxLength {
            return true
        }
        return false
    }
}
