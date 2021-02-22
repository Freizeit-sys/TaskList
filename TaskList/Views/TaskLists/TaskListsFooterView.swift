//
//  TaskListsFooterView.swift
//  TaskList
//
//  Created by Admin on 2021/02/20.
//

import UIKit

protocol TaskListsFooterViewDelegate: class {
    func didCreateNewList()
}

class TaskListsFooterView: UICollectionReusableView {
    
    weak var delegate: TaskListsFooterViewDelegate?
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.scheme.line
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        iv.tintColor = UIColor.scheme.icon
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create new list"
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
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
        self.addSubview(separator)
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        separator.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1.0)
        
        iconImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: self.topAnchor, left: self.iconImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tapGesture.addTarget(self, action: #selector(handleCreateNewList))
        self.addGestureRecognizer(tapGesture)
        
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.addTarget(self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleCreateNewList() {
        UIView.animate(withDuration: 0.15) {
            self.backgroundColor = .rgb(red: 229, green: 229, blue: 232)
        } completion: { (finished) in
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = .clear
            }
        }
        delegate?.didCreateNewList()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = UIColor.scheme.ink//.rgb(red: 229, green: 229, blue: 232)
            }
        case .ended:
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = .clear
            } completion: { (finished) in
                self.delegate?.didCreateNewList()
            }
        default:
            ()
        }
    }
}
