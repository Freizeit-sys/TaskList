//
//  TaskListController.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit

class TaskListController: UIViewController, TaskListViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private let v = TaskListView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix safe area top
//        if #available(iOS 11.0, *) {
//            additionalSafeAreaInsets.top = 60
//        } else {
//            let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
//            navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-topInset, for: .default)
//            navigationItem.leftBarButtonItem?.setBackgroundVerticalPositionAdjustment(-topInset, for: .default)
//        }
        
        //self.setupNavigationItems()
        self.setupViews()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupViews() {
        self.v.delegate = self
        self.v.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.v.collectionView.delegate = self
        self.v.collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .white
        cell.layer.applyMaterialShadow(elevation: 4)
        cell.layer.cornerRadius = 25
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * 32, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func didShowMenu() {
        print("show menu")
    }
    
    func didCreateTask() {
        print("create task")
    }
    
    func didShowOptions() {
        print("show options")
    }
}

extension TaskListController: HeaderViewDelegate {
    
    func didShowProfile() {
        let profileVC = ProfileViewController()
        profileVC.modalTransitionStyle = .crossDissolve
        profileVC.modalPresentationStyle = .overCurrentContext
        present(profileVC, animated: true, completion: nil)
    }
}

//import SwiftUI
//
//#if DEBUG
//struct MainPreview: PreviewProvider {
//
//    static var previews: some View {
//        Group {
//            ContainerView()
//                .previewDevice("iPhone 12")
//                .edgesIgnoringSafeArea(.all)
//                .environment(\.colorScheme, .light)
//
//                //ContainerView()
//                .previewDevice("iPhone 12")
//                .edgesIgnoringSafeArea(.all)
//                .environment(\.colorScheme, .dark)
//        }
//    }
//
//    struct ContainerView: UIViewControllerRepresentable {
//
//        func makeUIViewController(context: Context) -> some UIViewController {
//
//            let rootViewController = TaskListController()
//            let navigationController = UINavigationController(rootViewController: rootViewController)
//            navigationController.navigationBar.barTintColor = .white
//            navigationController.navigationBar.shadowImage = UIImage()
//            navigationController.navigationBar.isTranslucent = false
//
//            return navigationController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
//#endif
