//
//  DatePickerCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

protocol DatePickerCellDelegate: class {
    func didSelectDate(_ date: Date)
}

class DatePickerCell: UITableViewCell {
    
    weak var delegate: DatePickerCellDelegate?
    
    private let datePicker: CalendarView = {
        let cv = CalendarView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.scheme.background
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.backgroundColor = UIColor.scheme.background
        contentView.addSubview(datePicker)
        
        datePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        datePicker.didSelectDate = { [weak self] date in
            self?.delegate?.didSelectDate(date)
        }
    }
}
