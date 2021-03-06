//
//  TaskListView.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit

protocol TaskListViewDelegate: class {
    func didShowMenu()
    func didCreateTask()
    func didShowOptions()
}

class TaskListView: UIView {
    
    weak var delegate: TaskListViewDelegate?
    
    let tabBarHeight: CGFloat = 49
    
    let tabBar: CustomTabBar = {
        let view = CustomTabBar()
        view.backgroundColor = UIColor.scheme.surface
        view.layer.applyMaterialShadow(elevation: 8)
        view.layer.masksToBounds = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 40, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.alpha = 0.0
        cv.contentOffset.y = 0.0
        cv.alwaysBounceVertical = false
        cv.showsVerticalScrollIndicator = true
        return cv
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = UIColor.scheme.primary
        ai.hidesWhenStopped = true
        return ai
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.scheme.background
        
        self.addSubview(spinner)
        self.addSubview(collectionView)
        self.addSubview(tabBar)
        
        spinner.centerInSuperView()
        
        self.setupTabBar()
        self.setupCollectionView()
    }
    
    private func setupTabBar() {
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        
        tabBar.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.tabBarHeight + bottomInset)
        
        tabBar.menuButton.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
        tabBar.createTaskButton.addTarget(self, action: #selector(handleCreateTask), for: .touchUpInside)
        tabBar.optionsButton.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.tabBar.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func showSpinner(_ animated: Bool = true) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.collectionView.alpha = 0.0
            if animated { self.spinner.startAnimating() }
        }, completion: nil)
    }
    
    func hideSpinner(_ animated: Bool = true) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.collectionView.alpha = 1.0
            if animated { self.spinner.stopAnimating() }
        }, completion: nil)
    }
    
    @objc private func handleShowMenu() {
        delegate?.didShowMenu()
    }
    
    @objc private func handleCreateTask() {
        delegate?.didCreateTask()
    }
    
    @objc private func handleOptions() {
        delegate?.didShowOptions()
    }
}
