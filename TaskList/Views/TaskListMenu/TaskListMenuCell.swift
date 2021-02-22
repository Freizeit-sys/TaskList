//
//  TaskListMenuCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

class TaskListMenuCell: UICollectionViewCell {
    
    enum CellType {
        case normal
        case radio
    }
    
    var cellType: CellType? {
        didSet {
            guard let cellType = self.cellType else { return }
            switch cellType {
            case .normal:
                // Disabled radio button
                radioButton.alpha = 0.0
            case .radio: ()
                // Enabled radio button
                radioButton.alpha = 1.0
            }
        }
    }
    
    private let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(red: 46, green: 88, blue: 226)
        view.alpha = 0.0
        return view
    }()
    
    let radioButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "radio_unchecked")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.scheme.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.alpha = 0.0
        button.isEnabled = false
        return button
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "text text"
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
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
        addSubview(radioButton)
        addSubview(textLabel)
        
        selectedView.fillSuperView()
        
        radioButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        radioButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel.anchor(top: topAnchor, left: radioButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.addTarget(self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.15) { self.backgroundColor = .rgb(red: 229, green: 229, blue: 232) }
        case .ended:
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = .clear
            } completion: { (finished) in
                
            }
        default: break
        }
    }
    
    func toggleRadioButton() {
        radioButton.isEnabled = !radioButton.isEnabled
        
        let imageName = radioButton.isEnabled ? "radio_checked" : "radio_unchecked"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let color = radioButton.isEnabled ? UIColor.scheme.primary : UIColor.gray
        
        self.radioButton.tintColor = color
        self.radioButton.setImage(image, for: .normal)
        
        // Animation
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
//            self.radioButton.tintColor = color
//            self.radioButton.setImage(image, for: .normal)
//        }, completion: nil)
    }
}
