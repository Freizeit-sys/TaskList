//
//  TaskListInputFormView.swift
//  TaskList
//
//  Created by Admin on 2021/02/20.
//

import UIKit

protocol TaskListInputFormViewDelegate: class {
    func didCreate(text: String)
    func didRename(text: String)
    func didCancel()
}

class TaskListInputFormView: UIView {
    
    enum InputFormType {
        case create, rename
    }
    
    var inputFormType: InputFormType? {
        didSet {
            guard let _inputFormType = self.inputFormType else { return }
            switch _inputFormType {
            case .create:
                titleLabel.text = "Create new task list"
                createRenameButton.setTitle("Create", for: .normal)
                // Disable buttons at first.
                self.toggleCreateButtonIsEnable(false, animated: false)
            case .rename:
                titleLabel.text = "Rename task list"
                createRenameButton.setTitle("Rename", for: .normal)
                // Enabled buttons at first.
                self.toggleCreateButtonIsEnable(true, animated: false)
            }
        }
    }
    
    weak var delegate: TaskListInputFormViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create new task list"
        label.textColor = UIColor.scheme.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.textColor = UIColor.scheme.label
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter list name"
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let createRenameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.scheme.button, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.addTarget(self, action: #selector(handleCreateRename), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.scheme.button, for: .normal)
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
        addSubview(createRenameButton)
        addSubview(cancelButton)
        addSubview(textField)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        createRenameButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 36, width: 0, height: 0)
        
        cancelButton.anchor(top: nil, left: nil, bottom: createRenameButton.bottomAnchor, right: createRenameButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        createRenameButton.sizeToFit()
        cancelButton.sizeToFit()
        
        textField.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 48)
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        let isEnabled = textField.text == ""
        toggleCreateButtonIsEnable(!isEnabled)
    }
    
    private func toggleCreateButtonIsEnable(_ isEnabled: Bool, animated: Bool = true) {
        let textColor: UIColor = isEnabled ? .black : .lightGray
        UIView.transition(with: createRenameButton, duration: 0.3, options: .curveEaseOut) {
            self.createRenameButton.setTitleColor(textColor, for: .normal)
        } completion: { (finished) in
            self.createRenameButton.isEnabled = isEnabled
        }
    }
    
    @objc
    private func handleCreateRename() {
        guard let text = self.textField.text else { return }
        
        guard let _inputFormType = self.inputFormType else { return }
        switch _inputFormType {
        case .create:
            delegate?.didCreate(text: text)
        case .rename:
            delegate?.didRename(text: text)
        }
        
        // Measures against duplication of processing
        createRenameButton.isEnabled = false
    }
    
    @objc
    private func handleCancel() {
        delegate?.didCancel()
    }
}
