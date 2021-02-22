//
//  ProfileCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            guard let _image = self.image else { return }
            iconImageView.image = _image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var title: String? {
        didSet {
            guard let _title = self.title else { return }
            titleLabel.text = _title
        }
    }
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = UIColor.scheme.icon
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
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
        backgroundColor = .clear
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        iconImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: self.topAnchor, left: self.iconImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
    }
}
