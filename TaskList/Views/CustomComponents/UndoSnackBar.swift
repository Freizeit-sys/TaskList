//
//  UndoSnackBar.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

protocol UndoSnackBarDelegate: class {
    func didUndo(taskList: TaskList)
}

class UndoSnackBar: UIView {
    
    weak var delegate: UndoSnackBarDelegate?
    
    var taskList: TaskList? {
        didSet {
            guard let _taskList = self.taskList else { return }
            textLabel.text = _taskList.name
        }
    }
    
    private  let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.setTitleColor(UIColor.scheme.button, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
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
        backgroundColor = UIColor.scheme.surface
        layer.cornerRadius = 8
        layer.applyMaterialShadow(elevation: 4)
        layer.masksToBounds = false
        
        addSubview(undoButton)
        addSubview(textLabel)
        
        undoButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        undoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        textLabel.rightAnchor.constraint(lessThanOrEqualTo: undoButton.leftAnchor, constant: -16).isActive = true
        
        self.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.alpha = 1.0
        } completion: { (finished) in
            self.animateRemoveFromSuperview(delay: 4.0)
        }
    }
    
    private func animateRemoveFromSuperview(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
                self.alpha = 0.0
            } completion: { (finished) in
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func handleUndo() {
        guard let _taskList = self.taskList else { return }
        self.delegate?.didUndo(taskList: _taskList)
        self.animateRemoveFromSuperview(delay: 0.0)
    }
}
