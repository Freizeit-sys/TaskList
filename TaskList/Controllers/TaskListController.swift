//
//  TaskListController.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit
import GoogleSignIn

class TaskListController: UIViewController {
    
    var user: User?
    
    var tasklists: [TaskList] = []
    var currentTaskList: TaskList = TaskList(name: "My Tasks")
    
    private let config = FirestoreConfigRepository()
    private let authenticationService = AuthenticationService()
    private let firestoreTaskRepository = FirestoreTaskRepository()
    private let datasource = TaskListsDataSource()
    private let cellId = "cellId"
    private let emptyCellId = "emptyCellId"
    private let headerId = "headerId"
    private var headerView: TaskListHeaderView!
    
    let v = TaskListView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test
        //authenticationService.signOut()
        
        // Show sign in view
        let isLoggedIn: Bool = authenticationService.confirmLoggedIn()
        if !isLoggedIn {
            DispatchQueue.main.async {
                self.showSignInController()
            }
        } else {
            // Silent sign in
            authenticationService.googleRestorePreviousSignIn()
        }
        
        self.setupViews()
        self.setupNavigationBar()
    }
    
    func loadData() {
        let isLoggedIn: Bool = authenticationService.confirmLoggedIn()
        v.showSpinner(isLoggedIn)
        
        firestoreTaskRepository.fetchTaskLists { (tasklists) in
            self.tasklists = tasklists
            
            for (i, tasklist) in zip(self.tasklists.indices, self.tasklists) {
                guard let tasklistID = tasklist.id else { return }
                self.firestoreTaskRepository.fetchTasks(tasklistID: tasklistID) { (tasks) in
                    self.tasklists[i].tasks = tasks
                    
                    // All process done!!
                    if i == self.tasklists.count - 1 {
                        self.currentTaskList = self.tasklists[0]
                        
                        DispatchQueue.main.async {
                            self.v.hideSpinner(isLoggedIn)
                            self.v.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    func setCurrentTaskList() {
//        guard let currentTaskListID = config.currentTaskListID else { return print("AAAAAAAAA") }
//        let index = tasklists.firstIndex { (tasklist) -> Bool in
//            return tasklist.id == currentTaskListID
//        }
//        currentTaskList = tasklists[index ?? 0]
//    }
    
    private func showSignInController() {
        let signInController = SignInController()
        signInController.isModalInPresentation = true
        present(signInController, animated: true, completion: nil)
    }
    
    private func setupViews() {
        self.v.delegate = self
        self.v.collectionView.register(TaskCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(EmptyTaskCell.self, forCellWithReuseIdentifier: emptyCellId)
        self.v.collectionView.register(TaskListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.v.collectionView.delegate = self
        self.v.collectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.scheme.background
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func completeTask(at index: Int) {
        let fromIndexPath = IndexPath(item: index, section: 0)
        let toIndexPath = IndexPath(item: self.datasource.countTask() - 1, section: 0)
        
        self.v.collectionView.performBatchUpdates({
            self.datasource.completeTask(at: index)
            self.v.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
        }, completion: nil)
    }
    
    private func uncompleteTask(at index: Int) {
        let fromIndexPath = IndexPath(item: index, section: 0)
        let toIndexPath = IndexPath(item: 0, section: 0)
        
        self.v.collectionView.performBatchUpdates({
            self.datasource.uncompleteTask(at: index)
            self.v.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
        }, completion: nil)
    }
    
    private func reloadData() {
        self.v.collectionView.performBatchUpdates({
            let sections = IndexSet(integer: 0)
            self.v.collectionView.reloadSections(sections)
        }, completion: nil)
    }
}

extension TaskListController: TaskListViewDelegate {
    
    func didShowMenu() {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        let taskListsView = TaskListsView()
        taskListsView.tasklists = tasklists
        taskListsView.datasource = self.datasource
        taskListsView.frame = self.view.frame
        taskListsView.setupViews()
        
        // Show Create Task List View
        taskListsView.didCreateTaskList = { [weak self] in
            let createTaskListView = CreateTaskListView()
            createTaskListView.taskList = nil
            createTaskListView.frame = (self?.view.frame)!
            createTaskListView.setupViews()
            window?.addSubview(createTaskListView)
            
            createTaskListView.didSaveNewTaskList = { [weak self] newTaskList in
                // Add tasklist.
                self?.firestoreTaskRepository.addTaskList(newTaskList)
                
                // Change displayed task list.
                guard let index = self?.datasource.countTaskList() else { return }
                self?.datasource.changeTaskList(at: index - 1)
                self?.headerView.title = newTaskList.name
                
                // Reload data.
                self?.reloadData()
            }
        }
        
        taskListsView.didChangeTaskList = { [weak self] (title, index) in
            // Change displayed task list.
            guard let tasklists = self?.tasklists else { return }
            self?.currentTaskList = tasklists[index]
            
            //self?.datasource.changeTaskList(at: index)
            self?.headerView.title = self?.currentTaskList.name//title
            
            // Reload data
            self?.reloadData()
        }
        
        window?.addSubview(taskListsView)
    }
    
    func didCreateTask() {
        let createTaskVC = CreateTaskController()
        createTaskVC.modalTransitionStyle = .crossDissolve
        createTaskVC.modalPresentationStyle = .overCurrentContext
        
        createTaskVC.didSaveTask = { [weak self] newTask in
            self?.firestoreTaskRepository.addTask(newTask)
        }
        
        present(createTaskVC, animated: true, completion: nil)
    }
    
    func didShowOptions() {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        let menuView = TaskListMenuView()
        menuView.isInitialTaskList = self.datasource.isInitialTaskList()
        menuView.taskList = self.datasource.selectedTaskList()
        menuView.frame = self.view.frame
        menuView.setupViews()
        
        menuView.didSortList = { [weak self] sortType in
            // Sort task list.
            //self?.datasource.sortTaskList(sortType)
            guard let currentTaskList = self?.currentTaskList else { return }
            self?.firestoreTaskRepository.sortTaskList(currentTaskList, sortType: sortType, completion: { (sortedTasks) in
                self?.currentTaskList.tasks = sortedTasks
            })
            
            // Reload data.
            //self?.reloadData()
        }
        
        menuView.didRenameList = { [weak self] taskList in
            let createTaskListView = CreateTaskListView()
            createTaskListView.taskList = taskList
            createTaskListView.frame = (self?.view.frame)!
            createTaskListView.setupViews()
            window?.addSubview(createTaskListView)
            
            createTaskListView.didSaveRenameTaskList = { [weak self] (taskList) in
                // Rename task list.
                //self?.datasource.renameTaskList(taskList.name)
                self?.firestoreTaskRepository.renameTaskList(taskList)
                self?.headerView.title = taskList.name
                
                // Reload data.
                //self?.reloadData()
            }
        }
        
        menuView.didDeleteList = { [weak self] selectedTaskList in
            // Delete task list.
            self?.datasource.removeTaskList()
            
            // Show initial task list.
            let initialTaskList = self?.datasource.taskList(at: 0)
            self?.datasource.changeTaskList(at: 0)
            self?.headerView.title = initialTaskList?.name
            
            // Reload data.
            self?.reloadData()
            
            self?.showUndoSnackbar(selectedTaskList)
        }
        
        window?.addSubview(menuView)
    }
    
    private func showUndoSnackbar(_ taskList: TaskList) {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        
        let padding: CGFloat = 32.0
        let tabBarHeight: CGFloat = 49
        let bottomInset: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.bottom
        
        let height: CGFloat = 48
        let y: CGFloat = view.frame.height - height - (padding + tabBarHeight + bottomInset)
        
        let undoSnackBar = UndoSnackBar()
        undoSnackBar.delegate = self
        undoSnackBar.taskList = taskList
        undoSnackBar.frame = CGRect(x: 16, y: y, width: view.frame.width - 32, height: height)
        
        window?.addSubview(undoSnackBar)
    }
}

extension TaskListController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.datasource.countTask() > 0 {
//            return self.datasource.countTask()
//        }
//        return 1
        if currentTaskList.tasks.count > 0 {
            return currentTaskList.tasks.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if datasource.countTask() > 0 {
        if currentTaskList.tasks.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskCell
            cell.delegate = self
            
            let task = currentTaskList.tasks[indexPath.item] //self.datasource.task(at: indexPath.item)
            cell.task = task
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath) as! EmptyTaskCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? TaskListHeaderView
        //let taskList = self.datasource.selectedTaskList()
        headerView.title = currentTaskList.name//taskList.name
        headerView.profileImageURL = user?.photoURL
        headerView.delegate = self
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if datasource.countTask() > 0 {
        if currentTaskList.tasks.count > 0 {
            let dummyCell = TaskCell(frame: CGRect(x: 0, y: 0, width: view.frame.width - 2 * 32, height: 1000))
            
            let task = currentTaskList.tasks[indexPath.item]//self.datasource.task(at: indexPath.item)
            dummyCell.task = task
            
            dummyCell.layoutIfNeeded()
            
            let targetSize = CGSize(width: view.frame.width - 2 * 32, height: 1000)
            let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
            
            return CGSize(width: view.frame.width - 2 * 32, height: estimatedSize.height)
        }
        
        let paddingTop: CGFloat = 16
        let paddingBottom: CGFloat = 40
        let height: CGFloat = collectionView.frame.height - (100 + paddingTop + paddingBottom + v.safeAreaInsets.top + v.safeAreaInsets.bottom)
        return CGSize(width: view.frame.width - 2 * 32, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

extension TaskListController: TaskListHeaderViewDelegate {
    
    func didShowProfile() {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        
        let profileView = ProfileView()
        profileView.frame = self.view.frame
        profileView.user = self.user
        
        // Show Settings View Controller
        profileView.didSettings = { [weak self] in
            self?.showSettingsVC()
        }
        
        window?.addSubview(profileView)
    }
    
    private func showSettingsVC() {
        let settingsVC = SettingsController()
        present(settingsVC, animated: true, completion: nil)
    }
}

extension TaskListController: TaskCellDelegate {
    
    func didComplete(_ cell: TaskCell) {
        guard let indexPath = self.v.collectionView.indexPath(for: cell), let completed = cell.task?.completed else { return }
        
        if completed {
            self.completeTask(at: indexPath.item)
        } else {
            self.uncompleteTask(at: indexPath.item)
        }
        
        self.datasource.saveTaskLists()
    }
    
    func didEditTask(_ cell: TaskCell) {
        guard let indexPath = self.v.collectionView.indexPath(for: cell) else { return }
        let createTaskVC = CreateTaskController()
        createTaskVC.modalTransitionStyle = .crossDissolve
        createTaskVC.modalPresentationStyle = .overCurrentContext
        createTaskVC.task = cell.task
        createTaskVC.didSaveTask = { [weak self] task in
            self?.datasource.updateTask(at: indexPath.item, task)
            self?.reloadData()
        }
        present(createTaskVC, animated: true, completion: nil)
    }
    
    func didDeleteCell(_ cell: TaskCell) {
        guard let task = cell.task else { return }
        self.firestoreTaskRepository.deleteTask(task)
    }
}

extension TaskListController: UndoSnackBarDelegate {
    
    func didUndo(taskList: TaskList) {
        // Undo task list.
        self.datasource.appendTaskList(taskList)
        
        // Change displayed task list.
        let index = self.datasource.countTaskList() - 1
        self.datasource.changeTaskList(at: index)
        self.headerView.title = taskList.name
        
        // Reload data.
        self.reloadData()
    }
}
