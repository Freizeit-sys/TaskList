//
//  ArchiveImageView.swift
//  TaskList
//
//  Created by Admin on 2021/02/19.
//

import UIKit

class ArchiveImageView: UIView {
    
    let imageViewHeight: CGFloat = 44.0
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "archive")?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        iv.tintColor = .rgb(red: 46, green: 88, blue: 226)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = .white
        self.layer.applyMaterialShadow(elevation: 2)
        self.layer.cornerRadius = imageViewHeight / 2
        self.layer.masksToBounds = false
        
        addSubview(imageView)
        
        imageView.fillSuperView(UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10))
    }
}
