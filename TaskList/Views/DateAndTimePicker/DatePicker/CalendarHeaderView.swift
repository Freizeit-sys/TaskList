//
//  CalendarHeaderView.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

class CalendarHeaderView: UICollectionReusableView {
    
    var date: Date? {
        didSet {
            guard let date = self.date else { return }
            
            let dateString = date.string(format: "MMMM yyyy")
            yearMonthLabel.text = dateString
        }
    }
    
    private let yearMonthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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
        addSubview(yearMonthLabel)
        
        yearMonthLabel.centerInSuperView()
    }
}
