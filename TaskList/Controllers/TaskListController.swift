//
//  TaskListController.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit

class TaskListController: UIViewController {
    
    private let datasource = TaskListsDataSource()
    private let cellId = "cellId"
    private let headerId = "headerId"
    private var headerView: TaskListHeaderView!
    
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
    
    private func changeTaskListAndTitle(_ id: Int, title: String? = nil) {
        self.headerView.title = title
        self.datasource.changeTaskList(id: id)
    }
}

extension TaskListController: TaskListViewDelegate {
    
    func didShowMenu() {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        let taskListsView = TaskListsView()
        taskListsView.datasource = self.datasource
        taskListsView.frame = self.view.frame
        taskListsView.setupViews()
        
        // Show Create Task List View
        taskListsView.didCreateTaskList = { [weak self] in
            let createTaskListView = CreateTaskListView()
            createTaskListView.datasource = self?.datasource
            createTaskListView.frame = (self?.view.frame)!
            createTaskListView.setupViews()
            window?.addSubview(createTaskListView)
            
            createTaskListView.didSaveNewTaskList = { [weak self] taskList in
                self?.datasource.appendTaskList(taskList)
                self?.datasource.saveTaskLists()
                
                // Change the task list to be displayed
                self?.changeTaskListAndTitle(taskList.id, title: taskList.title)
                
                // Reload data
                self?.v.collectionView.reloadData()
            }
        }
        
        taskListsView.didChangeTaskList = { [weak self] id in
            // Change the task list to be displayed
            self?.changeTaskListAndTitle(id)
            
            // Reload data
            self?.v.collectionView.reloadData()
        }
        
        window?.addSubview(taskListsView)
    }
    
    func didCreateTask() {
        let createTaskVC = CreateTaskController()
        createTaskVC.didSaveTask = { [weak self] newTask in
            self?.datasource.appendTask(newTask)
            self?.v.collectionView.reloadData()
        }
        createTaskVC.modalTransitionStyle = .crossDissolve
        createTaskVC.modalPresentationStyle = .overCurrentContext
        present(createTaskVC, animated: true, completion: nil)
    }
    
    func didShowOptions() {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        let menuView = TaskListMenuView()
        menuView.selectedTaskList = self.datasource
        menuView.frame = self.view.frame
        menuView.setupViews()
        
        menuView.didSortList = { [weak self] soryType in
            self?.datasource.sortTaskList(soryType)
            self?.datasource.saveTaskLists()
            
            // Reload data
            self?.v.collectionView.reloadData()
        }
        
        menuView.didRenameList = { [weak self] taskList in
            self?.datasource.renameTaskList(taskList.title)
            self?.datasource.saveTaskLists()
            
            self?.changeTaskListAndTitle(taskList.id, title: taskList.title)
            
            // Reload data
            self?.v.collectionView.reloadData()
        }
        
        menuView.didDeleteList = { [weak self] taskList in
            self?.datasource.removeTaskList(id: taskList.id)
            self?.datasource.saveTaskLists()
            
//            let undoSnackBar = UndoSnackBar()
//            undoSnackBar.text = taskList.title
//            undoSnackBar.frame = self?.view.frame
            
            // Change to the initial list
            self?.changeTaskListAndTitle(0)
            // Reload data
            self?.v.collectionView.reloadData()
        }
        
        window?.addSubview(menuView)
    }
}

extension TaskListController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.countTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskCell
        cell.delegate = self
        
        let task = self.datasource.task(at: indexPath.item)
        cell.task = task
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? TaskListHeaderView
        let taskList = self.datasource.selectedTaskList()
        headerView.title = taskList.title
        headerView.delegate = self
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = TaskCell(frame: CGRect(x: 0, y: 0, width: view.frame.width - 2 * 32, height: 1000))
        
        let task = self.datasource.task(at: indexPath.item)
        dummyCell.task = task
        
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width - 2 * 32, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: view.frame.width - 2 * 32, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

extension TaskListController: TaskListHeaderViewDelegate {
    
    func didShowProfile() {
        let profileVC = ProfileController()
        profileVC.modalTransitionStyle = .crossDissolve
        profileVC.modalPresentationStyle = .overCurrentContext
        present(profileVC, animated: true, completion: nil)
    }
}

extension TaskListController: TaskCellDelegate {
    
    func didCheck(complete: Bool) {
        // change datasource
    }
    
    func didDeleteCell(_ cell: TaskCell) {
        if let indexPath: IndexPath = self.v.collectionView.indexPath(for: cell) {
            self.v.collectionView.performBatchUpdates({
                self.datasource.removeTask(at: indexPath.item)
                self.v.collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
}
