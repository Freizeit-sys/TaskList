//
//  TaskListMenuHeaderView.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

class TaskListMenuHeaderView: UICollectionReusableView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Sort by"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 1
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
        backgroundColor = .clear
        
        addSubview(label)
        label.fillSuperView(.init(top: 0, left: 24, bottom: 0, right: 0))
    }
}
