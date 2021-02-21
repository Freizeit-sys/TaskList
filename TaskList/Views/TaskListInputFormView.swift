//
//  TaskListInputFormView.swift
//  TaskList
//
//  Created by Admin on 2021/02/20.
//

import UIKit

protocol TaskListInputFormViewDelegate: class {
    func didCreate()
    func didCancel()
}

class TaskListInputFormView: UIView {
    
    weak var delegate: TaskListInputFormViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create new task list"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter list name"
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
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
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.applyMaterialShadow(elevation: 8)
        layer.masksToBounds = false
        
        addSubview(titleLabel)
        addSubview(createButton)
        addSubview(cancelButton)
        addSubview(textField)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        createButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 36, width: 0, height: 0)
        
        cancelButton.anchor(top: nil, left: nil, bottom: createButton.bottomAnchor, right: createButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        createButton.sizeToFit()
        cancelButton.sizeToFit()
        
        textField.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 48)
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        let isEnabled = textField.text == ""
        toggleCreateButtonIsEnable(!isEnabled)
    }
    
    private func toggleCreateButtonIsEnable(_ isEnabled: Bool) {
        let textColor: UIColor = isEnabled ? .black : .lightGray
        UIView.transition(with: createButton, duration: 0.3, options: .curveEaseOut) {
            self.createButton.setTitleColor(textColor, for: .normal)
        } completion: { (finished) in
            self.createButton.isEnabled = isEnabled
        }
    }
    
    @objc
    private func handleCreate() {
        // Measures against duplication of processing
        createButton.isEnabled = false
        delegate?.didCreate()
    }
    
    @objc
    private func handleCancel() {
        delegate?.didCancel()
    }
}
