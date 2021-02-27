//
//  DateTimePickerHeaderView.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

protocol DateTimePickerHeaderViewDelegate: class {
    func didDone()
}

class DateTimePickerHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: DateTimePickerHeaderViewDelegate?
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Date & Time"
        label.textColor = UIColor.scheme.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.scheme.button, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {        
        contentView.backgroundColor = UIColor.scheme.background
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(doneButton)
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = false
        
        dateTimeLabel.fillSuperView()
        
        doneButton.anchor(top: nil, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    }
    
    @objc private func handleDone() {
        self.delegate?.didDone()
    }
}

