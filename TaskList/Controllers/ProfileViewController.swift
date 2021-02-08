//
//  ProfileViewController.swift
//  TaskList
//
//  Created by Admin on 2021/02/07.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewDelegate, ProfileHeaderViewDelegate {
    
    private let imageNames = ["settings", "about"]
    private let titles = ["Settings", "About"]

    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private let v = ProfileView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.v.delegate = self
        self.v.collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.v.collectionView.delegate = self
        self.v.collectionView.dataSource = self
    }
    
    func didBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didback() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileCell
        
        let image = UIImage(named: imageNames[indexPath.item])
        let title = titles[indexPath.item]
        cell.image = image
        cell.title = title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeaderView
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * 40, height: self.v.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: self.v.headerHeight)
    }
}
