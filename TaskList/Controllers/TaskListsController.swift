//
//  TaskListsController.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

//class TaskListsController: UIViewController, TaskListsViewDelegate {
//
//    var datasource: TaskListsDataSource!
//
//    private let cellId = "cellId"
//    private let footerId = "footerId"
//
//    private let v = TaskListsView()
//
//    override func loadView() {
//        self.view = v
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.setupViews()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.showCollectionView()
//    }
//
//    private func setupViews() {
//        self.v.delegate = self
//        self.v.collectionView.register(TaskListsCell.self, forCellWithReuseIdentifier: cellId)
//        self.v.collectionView.register(TaskListsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
//        self.v.collectionView.delegate = self
//        self.v.collectionView.dataSource = self
//    }
//
//    private func showCollectionView() {
//        let padding: CGFloat = 16.0
//        let taskListsCount = CGFloat(self.datasource!.countTaskList())
//        v.collectionViewHeightAnchor.constant += v.cellHeight * taskListsCount + padding
//        v.collectionViewTopAnchor.constant -= v.collectionViewHeightAnchor.constant
//
//        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut) {
//            self.v.layoutIfNeeded()
//        } completion: { (finished) in }
//    }
//
//    private func hideCollectionView() {
//        v.collectionViewHeightAnchor.constant = 0
//        v.collectionViewTopAnchor.constant = 0
//
//        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveLinear) {
//            self.v.layoutIfNeeded()
//        } completion: { (finished) in }
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func didBack() {
//        hideCollectionView()
//    }
//}
//
//extension TaskListsController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.datasource!.countTaskList()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskListsCell
//
//        let taskList = self.datasource.taskList(at: indexPath.item)
//        cell.taskList = taskList
//
//        let isSelected = (taskList?.selected)!
//
//        if isSelected {
//            cell.selectedView.alpha = 0.2
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as! TaskListsFooterView
//        footer.delegate = self
//        return footer
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: v.cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: v.footerHeight)
//    }
//}
//
//extension TaskListsController: TaskListsFooterViewDelegate {
//
//    func didCreateNewList() {
//        print("create new list")
//    }
//}
