//
//  TaskListHeaderView.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

protocol TaskListHeaderViewDelegate: class {
    func didShowProfile()
}

class TaskListHeaderView: UICollectionReusableView {
    
    weak var delegate: TaskListHeaderViewDelegate?
    
    var title: String? {
        didSet {
            guard let title = self.title else { return }
            
            let attributes1: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.scheme.secondaryLabel,
                .font: UIFont.systemFont(ofSize: 14)
            ]
            
            let attributes2: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.scheme.label,
                .font: UIFont.systemFont(ofSize: 26, weight: .bold)
            ]
            
            let attributedText = NSMutableAttributedString(string: "14.05.2020 \n", attributes: attributes1)
            attributedText.append(NSAttributedString(string: title, attributes: attributes2))
            
            titleLabel.attributedText = attributedText
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let profileImageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.scheme.surface
        view.layer.cornerRadius = 48 / 2
        view.layer.applyMaterialShadow(elevation: 4)
        return view
    }()
    
    let profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 48 / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.scheme.background
        
        addSubview(titleLabel)
        addSubview(profileImageShadowView)
        profileImageShadowView.addSubview(profileImageButton)
        
        titleLabel.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        
        profileImageShadowView.anchor(top: nil, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 40, width: 48, height: 48)
        
        profileImageButton.fillSuperView()
        
        profileImageButton.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
    }
    
    @objc func handleShowProfile() {
        delegate?.didShowProfile()
    }
}
