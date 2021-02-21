//
//  TaskListMenuFooterView.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

class TaskListMenuFooterView: UICollectionReusableView {
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(separatorView)
        separatorView.fillSuperView()
    }
}
