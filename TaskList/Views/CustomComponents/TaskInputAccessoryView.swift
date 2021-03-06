//
//  TaskInputAccessoryView.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import UIKit

protocol TaskInputAccessoryViewDelegate: class {
    func didBack()
    func didSave(_ task: Task)
    func didShowDateTimePicker()
}

class TaskInputAccessoryView: UIView {
    
    weak var delegate: TaskInputAccessoryViewDelegate?
    
    var task: Task? {
        didSet {
            guard let _task = self.task else { return }
            textField.text = _task.title
            duedateButton.duedate = _task.duedate ?? Date()
            
            if task?.title != "" {
                saveButton.setTitleColor(UIColor.scheme.primary, for: .normal)
                saveButton.isEnabled = true
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create new task"
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.scheme.label
        tf.placeholder = "New task"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    let duedateButton: DueDateButton = {
        let button = DueDateButton()
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
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
        backgroundColor = UIColor.scheme.background
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        duedateButton.duedate = Date()
        textField.delegate = self
        
        addSubview(titleLabel)
        addSubview(saveButton)
        addSubview(textField)
        addSubview(duedateButton)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        saveButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 24, width: 48, height: 0)
        
        textField.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: saveButton.leftAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 48)
        
        duedateButton.anchor(top: textField.bottomAnchor, left: textField.leftAnchor, bottom: saveButton.bottomAnchor, right: textField.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 36)
        
        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        duedateButton.addGestureRecognizer(tapGesture)
    }
    
    public func setSelectedDate(_ date: Date) {
        duedateButton.duedate = date
    }
    
    public func clearCommentTextField() {
        textField.text = nil
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        let isEnabled = textField.text == ""
        toggleSaveButtonIsEnabled(!isEnabled)
    }
    
    private func toggleSaveButtonIsEnabled(_ isEnabled: Bool) {
        let textColor: UIColor = isEnabled ? UIColor.scheme.primary : .systemGray
        UIView.transition(with: saveButton, duration: 0.3, options: .curveEaseOut) {
            self.saveButton.setTitleColor(textColor, for: .normal)
        } completion: { (finished) in
            self.saveButton.isEnabled = isEnabled
        }
    }
    
    private func saveNewTask() {
        guard let title = textField.text, let duedate = self.duedateButton.duedate else {
            return print("")
        }
        let newTask = Task(title: title, duedate: duedate)
        delegate?.didSave(newTask)
    }
    
    @objc
    private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        self.delegate?.didShowDateTimePicker()
    }
    
    @objc
    private func handleSave() {
        self.saveNewTask()
    }
}

extension TaskInputAccessoryView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            self.saveNewTask()
            return true
        }
        delegate?.didBack()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength: Int = 40
        let text = textField.text! + string
        
        if text.count <= maxLength {
            return true
        }
        return false
    }
}


// MARK: - DueDateButton

class DueDateButton: UIView {
    
    var duedate: Date? {
        didSet {
            guard let _duedate = self.duedate else { return }
            
            let week = _duedate.week()
            let date = _duedate.string(format: "yyyy年MM月dd日 (\(week))")
            let time = _duedate.string(format: "HH:mm")
            
            dateButton.setTitle(date, for: .normal)
            timeButton.setTitle(time, for: .normal)
            
            dateButton.sizeToFit()
            timeButton.sizeToFit()
        }
    }
    
    private let dateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.scheme.surface
        button.setTitleColor(UIColor.scheme.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.isEnabled = false
        button.layer.cornerRadius = 4
        button.layer.applyMaterialShadow(elevation: 2)
        button.layer.masksToBounds = false
        return button
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.scheme.surface
        button.setTitleColor(UIColor.scheme.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.isEnabled = false
        button.layer.cornerRadius = 4
        button.layer.applyMaterialShadow(elevation: 2)
        button.layer.masksToBounds = false
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
        addSubview(dateButton)
        addSubview(timeButton)
        
        dateButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        timeButton.anchor(top: topAnchor, left: dateButton.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

