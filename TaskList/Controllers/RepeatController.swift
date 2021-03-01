//
//  RepeatController.swift
//  TaskList
//
//  Created by Admin on 2021/03/01.
//

import UIKit

class RepeatView: UIView {
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = false
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
        backgroundColor = UIColor.scheme.secondaryBackground
        
        addSubview(collectionView)
        
        collectionView.fillSuperView()
    }
}

class RepeatController: UIViewController {
    
    var task: Task?
    
    var didSetRepeat: ((_ repeat: Repeat) -> Void)?
    
    private let padding: CGFloat = 24.0
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let cellData: [String] = [
        "Does not repeat",
        "Every day",
        "Every week on Monday",
        "Every month on the first Monday",
        "Every month on day 1",
        "Every year",
        "Every weekday (Mon-Fri)"
    ]
    
    private let v = RepeatView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _repeat = self.task?.repeat else { return }
        self.didSetRepeat?(_repeat)
    }
    
    private func setupCollectionView() {
        v.collectionView.register(RepeatCell.self, forCellWithReuseIdentifier: cellId)
        v.collectionView.register(RepeatHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        v.collectionView.delegate = self
        v.collectionView.dataSource = self
    }
}

extension RepeatController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RepeatCell
        cell.isChecked = true
        
        guard let _repeat = Repeat(rawValue: indexPath.item) else { return }
        self.task?.repeat = _repeat
        print(_repeat)
        self.didSetRepeat?(_repeat)
        
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RepeatCell
        cell.text = cellData[indexPath.item]
        
        guard let _task = self.task else { return cell }
        if indexPath.item == _task.repeat.rawValue {
            cell.isChecked = true
        } else {
            cell.isChecked = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! RepeatHeaderView
        headerView.delegate = self
        headerView.title = "Repeat"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 96)
    }
}

extension RepeatController: RepeatHeaderViewDelegate {
    
    func didBack() {
        guard let _repeat = task?.repeat else { return }
        self.didSetRepeat?(_repeat)
        dismiss(animated: true, completion: nil)
    }
}

class RepeatCell: UICollectionViewCell {
    
    var text: String? {
        didSet {
            guard let _text = self.text else { return }
            textLabel.text = _text
        }
    }
    
    var isChecked: Bool? {
        didSet {
            guard let _isChecked = self.isChecked else { return }
            
            let image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
            checkButton.setImage(image, for: .normal)
            
            let alpha: CGFloat = _isChecked ? 1.0 : 0.0
            checkButton.alpha = alpha
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.scheme.primary
        let image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(textLabel)
        addSubview(checkButton)
        
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        checkButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 24, height: 24)
    }
}

protocol RepeatHeaderViewDelegate: class {
    func didBack()
}

class RepeatHeaderView: UICollectionReusableView {
    
    weak var delegate: RepeatHeaderViewDelegate?
    
    var title: String? {
        didSet {
            guard let _title = self.title else { return }
            titleLabel.text = _title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.scheme.button
        let image = UIImage(named: "back_large")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(titleLabel)
        addSubview(backButton)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        backButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 56, height: 56)
        backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    @objc private func handleBack() {
        self.delegate?.didBack()
    }
}
