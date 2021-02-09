//
//  TaskListsViewController.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

protocol TaskListsFooterViewDelegate: class {
    func didCreateNewList()
}

class TaskListsFooterView: UICollectionReusableView {
    
    weak var delegate: TaskListsFooterViewDelegate?
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(red: 229, green: 229, blue: 232)
        return view
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create new list"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.addSubview(separator)
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        separator.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1.0)
        
        iconImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: self.topAnchor, left: self.iconImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tapGesture.addTarget(self, action: #selector(handleCreateNewList))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleCreateNewList() {
        delegate?.didCreateNewList()
    }
}

protocol TaskListsViewDelegate: class {
    func didBack()
}

class TaskListsView: UIView {
    
    weak var delegate: TaskListsViewDelegate?
    
    var collectionViewHeightAnchor: NSLayoutConstraint!
    
    let cellHeight: CGFloat = 48
    let footerHeight: CGFloat = 48
    
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
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 15
        cv.layer.applyMaterialShadow(elevation: 4)
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
        self.addSubview(overlayView)
        self.addSubview(collectionView)
        
        overlayView.fillSuperView()
        
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        collectionView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: cellHeight + footerHeight + bottomInset)
        collectionViewHeightAnchor.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        tapGesture.cancelsTouchesInView = false
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleBack() {
        delegate?.didBack()
    }
}

class TaskListsViewController: UIViewController, TaskListsViewDelegate {
    
    private var itemNum = 1
    
    private let cellId = "cellId"
    private let footerId = "footerId"
    
    private let v = TaskListsView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.v.delegate = self
        self.v.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(TaskListsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        self.v.collectionView.delegate = self
        self.v.collectionView.dataSource = self
    }
    
    private func updateCollectionViewHeight() {
        
    }
    
    func didBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TaskListsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as! TaskListsFooterView
        footer.delegate = self
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: v.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: v.footerHeight)
    }
}

extension TaskListsViewController: TaskListsFooterViewDelegate {
    
    func didCreateNewList() {
        print("create new list")
    }
}
