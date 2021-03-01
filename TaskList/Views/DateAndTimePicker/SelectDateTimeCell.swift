//
//  SelectDateTimeCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

protocol SelectDateTimeCellDelegate: class {
    func didClear(cell: SelectDateTimeCell)
}

class SelectDateTimeCell: UITableViewCell {
    
    weak var delegate: SelectDateTimeCellDelegate?
        
    var date: Date? {
        didSet {
            guard let date = self.date else { return }
            dateOrTimeLabel.text = date.string(format: "EEEE, MM dd")
        }
    }
    
    var time: Date? {
        didSet {
            if let time = self.time {
                dateOrTimeLabel.text = time.string(format: "HH:mm")
            } else {
                dateOrTimeLabel.text = "Set time"
            }
        }
    }
    
    private let dateOrTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.scheme.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.scheme.button
        return button
    }()
    
    @objc private func handleClear() {
        self.delegate?.didClear(cell: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.backgroundColor = UIColor.scheme.secondaryBackground
        contentView.addSubview(dateOrTimeLabel)
        contentView.addSubview(clearButton)
        
        dateOrTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dateOrTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        dateOrTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        clearButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -14).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        clearButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
    }
    
    public func showClearButton() {
        clearButton.alpha = 1.0
        clearButton.isEnabled = true
    }
    
    public func hideClearButton() {
        clearButton.alpha = 0.0
        clearButton.isEnabled = false
    }
}

