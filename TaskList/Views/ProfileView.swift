//
//  ProfileView.swift
//  TaskList
//
//  Created by Admin on 2021/02/07.
//

import UIKit

class ProfileView: UIView {
    
    public var didSettings: (() -> ())?
    
    private let cellData: [(imageName: String, title: String)] = [(imageName: "settings", title: "Settings"), (imageName: "about", title: "About")]

    private let cellId = "cellId"
    private let headerId = "headerId"
    
    let cellHeight: CGFloat = 56
    let headerHeight: CGFloat = 84
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.scheme.background
        cv.alpha = 0.0
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
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 150, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: cellHeight * CGFloat(cellData.count) + headerHeight)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        tapGesture.cancelsTouchesInView = false
        overlayView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.overlayView.alpha = 1.0
            self.collectionView.alpha = 1.0
        }, completion: nil)
    }
    
    private func dismiss(_ completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0.0
            self.collectionView.alpha = 0.0
        } completion: { (finished) in
            self.removeFromSuperview()
            
            if let _completion = completion {
                _completion()
            }
        }
    }
    
    @objc func handleBack() {
        self.dismiss(nil)
    }
}

extension ProfileView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileCell
        
        let imageName = cellData[indexPath.item].imageName
        let image = UIImage(named: imageName)
        let title = cellData[indexPath.item].title
        cell.image = image
        cell.title = title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeaderView
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        // Settings
        if index == 0 {
            self.dismiss { self.didSettings?() }
            return
        }
        
        // About
        if index == 1 {
            // Coming soon
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 2 * 40, height: self.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: self.headerHeight)
    }
}

extension ProfileView: ProfileHeaderViewDelegate {
    
    func didback() {
        self.dismiss(nil)
    }
}
