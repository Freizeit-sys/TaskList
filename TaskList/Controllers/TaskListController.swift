//
//  TaskListController.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit

class TaskListController: UIViewController {
    
    private var itemNum = 4

    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private let v = TaskListView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupViews() {
        self.v.delegate = self
        self.v.collectionView.register(TaskCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(TaskListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.v.collectionView.delegate = self
        self.v.collectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .rgb(red: 242, green: 246, blue: 254)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }
}

extension TaskListController: TaskListViewDelegate {
    
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

extension TaskListController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! TaskListHeaderView
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * 32, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

extension TaskListController: TaskListHeaderViewDelegate {
    
    func didShowProfile() {
        let profileVC = ProfileViewController()
        profileVC.modalTransitionStyle = .crossDissolve
        profileVC.modalPresentationStyle = .overCurrentContext
        present(profileVC, animated: true, completion: nil)
    }
}

extension TaskListController: TaskCellDelegate {
    
    func didCheck(complete: Bool) {
        
    }
    
    func didDeleteCell(_ cell: TaskCell) {
        if let indexPath: IndexPath = self.v.collectionView.indexPath(for: cell) {
            self.v.collectionView.performBatchUpdates({
                self.itemNum -= 1
                self.v.collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
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
