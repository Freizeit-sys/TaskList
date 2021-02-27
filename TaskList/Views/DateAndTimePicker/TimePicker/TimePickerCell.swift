//
//  TimePickerCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

protocol TimePickerCellDelegate: class {
    func didSelectTime(_ date: Date)
}

class TimePickerCell: UITableViewCell {
    
    weak var delegate: TimePickerCellDelegate?
    
    var time: Date? {
        didSet {
            guard let time = self.time else { return }
            timePicker.date = time
        }
    }
    
    private let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .time
        dp.timeZone = Date().calendar.timeZone
        dp.locale = Date().calendar.locale
        dp.minuteInterval = 1
        return dp
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
        contentView.addSubview(timePicker)
        
        timePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        timePicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        timePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        timePicker.addTarget(self, action: #selector(handleTimePickerValueChanged), for: .valueChanged)
    }
    
    @objc private func handleTimePickerValueChanged(_ sender: UIDatePicker) {
        self.delegate?.didSelectTime(sender.date)
    }
}
