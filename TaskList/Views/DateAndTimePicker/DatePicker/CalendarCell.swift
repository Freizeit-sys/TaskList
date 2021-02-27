//
//  CalendarCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var week: String? {
        didSet {
            guard let week = self.week else { return }
            textLabel.text = week
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = self.date else {
                textLabel.text = nil
                return
            }
            let day = date.day
            textLabel.text = "\(day)"
        }
    }
    
    private let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.scheme.primary
        view.alpha = 0.0
        view.layer.cornerRadius = 28 / 2
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.scheme.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(selectedView)
        addSubview(textLabel)
        
        selectedView.centerInSuperView()
        selectedView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        selectedView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        textLabel.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.selectedView.alpha = 0.0
    }
    
    func showSelectedView() {
        UIView.animate(withDuration: 0.3) {
            self.selectedView.alpha = 0.2
        }
    }
    
    func hideSelectedView() {
        UIView.animate(withDuration: 0.3) {
            self.selectedView.alpha = 0.0
        }
    }
}
