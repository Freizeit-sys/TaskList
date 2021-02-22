//
//  ProfileView.swift
//  TaskList
//
//  Created by Admin on 2021/02/07.
//

import UIKit

protocol ProfileViewDelegate: class {
    func didBack()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    let itemNum = 2
    let cellHeight: CGFloat = 56
    let headerHeight: CGFloat = 84
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.scheme.background
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 15
        cv.layer.applyMaterialShadow(elevation: 12)
        cv.layer.masksToBounds = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(overlayView)
        addSubview(collectionView)
        
        overlayView.fillSuperView()
        
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 150, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: cellHeight * CGFloat(itemNum) + headerHeight)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        tapGesture.cancelsTouchesInView = false
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleBack() {
        delegate?.didBack()
    }
}
