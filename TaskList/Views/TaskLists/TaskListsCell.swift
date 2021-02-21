//
//  TaskListsCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/20.
//

import UIKit

class TaskListsCell: UICollectionViewCell {
    
    var taskList: TaskList? {
        didSet {
            guard let taskList = self.taskList else { return }
            
            let title = taskList.title
            titleLabel.text = title
            
            let count = taskList.tasks.count
            countLabel.text = count == 0 ? "No Tasks" : "\(count) Tasks"
        }
    }
    
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(red: 46, green: 88, blue: 226)
        view.alpha = 0.0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(selectedView)
        addSubview(countLabel)
        addSubview(titleLabel)
        
        selectedView.fillSuperView()
        
        countLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 58, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selectedView.alpha = 0.0
    }
}
