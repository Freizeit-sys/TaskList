//
//  UndoSnackBar.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

class UndoSnackBar: UIView {
    
    var text: String? {
        didSet {
            guard let _text = self.text else { return }
            textLabel.text = _text
        }
    }
    
    private  let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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
        addSubview(undoButton)
        addSubview(textLabel)
        
        undoButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        undoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: undoButton.leftAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        
        layer.cornerRadius = 8
        layer.applyMaterialShadow(elevation: 4)
        layer.masksToBounds = false
    }
}
