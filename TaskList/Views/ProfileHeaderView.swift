//
//  ProfileHeaderView.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func didback()
}

class ProfileHeaderView: UICollectionReusableView {
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    let profileImageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 44 / 2
        view.layer.applyMaterialShadow(elevation: 4)
        view.layer.masksToBounds = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        iv.image = image
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 44 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "example123@gmail.com"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        self.addSubview(profileImageShadowView)
        profileImageShadowView.addSubview(profileImageView)
        self.addSubview(usernameLabel)
        self.addSubview(emailLabel)
        self.addSubview(backButton)
        self.addSubview(separator)
        
        self.profileImageShadowView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        
        self.profileImageView.fillSuperView()
        
        self.backButton.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 24, height: 24)
        
        self.usernameLabel.anchor(top: self.profileImageShadowView.topAnchor, left: self.profileImageShadowView.rightAnchor, bottom: self.profileImageShadowView.centerYAnchor, right: self.backButton.leftAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        self.emailLabel.anchor(top: self.profileImageShadowView.centerYAnchor, left: self.profileImageShadowView.rightAnchor, bottom: self.profileImageShadowView.bottomAnchor, right: self.backButton.leftAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 4, paddingRight: 10, width: 0, height: 0)
        
        self.separator.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc private func handleBack() {
        delegate?.didback()
    }
}
