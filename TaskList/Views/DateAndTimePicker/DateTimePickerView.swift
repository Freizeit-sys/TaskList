//
//  DateTimePickerView.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

protocol DateTimePickerViewDelegate: class {
    func didDone(_ date: Date)
    func didShowIsRepeatVC()
}

class DateTimePickerView: UIView {
    
    weak var delegate: DateTimePickerViewDelegate?
    
    private enum Section: Int {
        case datePicker, timePicker, `repeat`
    }
    
    private var isTimePicker = false
    
    private var selectedDate: Date?
    private var selectedTime: Date?
    
    private let cellId1 = "cellId1"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"
    private let cellId4 = "cellId4"
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView(frame: .zero)
        tv.separatorInset = .zero
        tv.separatorStyle = .singleLine
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(tableView)
        
        tableView.fillSuperView()
        
        tableView.register(SelectDateTimeCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: cellId2)
        tableView.register(TimePickerCell.self, forCellReuseIdentifier: cellId3)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId4)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func changePickerMode() {
        isTimePicker.toggle()
        
        if isTimePicker {
            showTimePicker()
        } else {
            hideTimePicker()
        }
    }
    
    private func showTimePicker() {
        tableView.performBatchUpdates {
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            
        } completion: { (finished) in
            
            self.tableView.performBatchUpdates({
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }, completion: nil)
        }
    }
    
    private func hideTimePicker() {
        tableView.performBatchUpdates {
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            
        } completion: { (finished) in
            
            self.tableView.performBatchUpdates({
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DateTimePickerView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .datePicker:
            
            if isTimePicker {
                changePickerMode()
            }
            
        case .timePicker:
            
            if !isTimePicker && indexPath.item == 0 {
                
                if selectedTime == nil {
                    selectedTime = Date()
                }
                
                changePickerMode()
            }
            
        case .repeat:
            
            self.delegate?.didShowIsRepeatVC()
            
        case .none:
            break
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .datePicker:
            return 1
        case .timePicker:
            return isTimePicker ? 2 : 1
        case .repeat:
            return 1
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .datePicker:
            
            if isTimePicker {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! SelectDateTimeCell
                cell.selectionStyle = .none
                cell.date = selectedDate ?? Date()
                cell.hideClearButton()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! DatePickerCell
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }
            
        case .timePicker:
            
            if indexPath.item == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! SelectDateTimeCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.time = selectedTime ?? nil
                
                if selectedTime != nil {
                    cell.showClearButton()
                } else {
                    cell.hideClearButton()
                }
                
                return cell
            }
            
            if indexPath.item == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! TimePickerCell
                cell.delegate = self
                cell.time = selectedTime ?? Date()
                cell.selectionStyle = .none
                return cell
            }
            
        case .repeat:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId4, for: indexPath)
            cell.backgroundColor = UIColor.scheme.background
            cell.textLabel?.text = "Does not repeat"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
            
        case .none:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .datePicker:
            
            if isTimePicker {
                return 44
            } else {
                return 230
            }
            
        case .timePicker:
            
            if indexPath.item == 0 {
                return 44
            }
            
            if indexPath.item == 1 && isTimePicker {
                return 186
            }
            
            if indexPath.item == 1 && !isTimePicker {
                return .zero
            }
        
        case .repeat:
            return 44
        case .none:
            return .zero
        }
        
        return .zero
    }
    
    // MARK: TableView HeaderView
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DateTimePickerHeaderView()
        headerView.delegate = self
        headerView.tintColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }
        return .zero
    }
}

// MARK: - Extensitons Custom Cell And Custom HeaderView

extension DateTimePickerView: SelectDateTimeCellDelegate, DatePickerCellDelegate, TimePickerCellDelegate, DateTimePickerHeaderViewDelegate {
    
    // MARK: - SelectDateOrTimeCellDelegate
    
    func didClear(cell: SelectDateTimeCell) {
        selectedTime = nil
        
        if isTimePicker {
            isTimePicker.toggle()
            hideTimePicker()
        } else {
            cell.time = nil
        }
    }
    
    // MARK: - DatePickerCellDelegate
    
    func didSelectDate(_ selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    // MARK: - TimePickerCellDelegate
    
    // Set selected time
    func didSelectTime(_ date: Date) {
        let selectTimeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SelectDateTimeCell
        selectTimeCell.time = date
        selectTimeCell.showClearButton()
        
        if selectedTime != nil {
            selectedTime = selectedTime?.fixed(hour: date.hour, minute: date.minute)
        } else {
            selectedTime = Date().fixed(hour: date.hour, minute: date.minute)
        }
    }
    
    // MARK: - DateTimePickerHeaderViewDelegate
    
    func didDone() {
        let date = Date().zeroclock.fixed(year: selectedDate?.year, month: selectedDate?.month, day: selectedDate?.day, hour: selectedTime?.hour, minute: selectedTime?.minute, second: 0)
        self.delegate?.didDone(date)
    }
}
