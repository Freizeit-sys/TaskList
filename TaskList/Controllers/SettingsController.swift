//
//  SettingsController.swift
//  TaskList
//
//  Created by Admin on 2021/02/07.
//

import UIKit

class SettingsView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
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
        addSubview(collectionView)
        collectionView.fillSuperView()
    }
}

enum AccessoryType {
    case `switch`, disclosure, none
}

class SettingsController: UIViewController {
    
    private let sectionTitles: [String] = ["Settings", "GENERAL", "APP ICON", "THEME", "CONTACT"]
    private let cellData: [[(text: String, type: AccessoryType)]] = [
        [(text: "Notifications", type: .switch)],
        [(text: "icon1", type: .none)],
        [(text: "theme1", type: .none)],
        [(text: "Write a Review", type: .disclosure), (text: "Help & Feedback", type: .disclosure)]
    ]
    
    private let padding: CGFloat = 16.0
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private let v = SettingsView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.v.backgroundColor = UIColor.scheme.background
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.v.collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(SettingsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.v.collectionView.delegate = self
        self.v.collectionView.dataSource = self
    }
}

class SettingsCell: UICollectionViewCell {
    
    var cellData: (text: String, type: AccessoryType)? {
        didSet {
            guard let _cellData = self.cellData else { return }
            
            let text = _cellData.text
            textLabel.text = text
            
            let type = _cellData.type
            switch type {
            case .switch:
                self.accessoryView.key = text
                self.accessoryView.accessoryType = .switch
            case .disclosure:
                let image = (UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate))!
                self.accessoryView.setImage(image)
                self.accessoryView.accessoryType = .disclosure
            case .none:
                ()
            }
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let accessoryView: AccessoryView = {
        let av = AccessoryView()
        return av
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.scheme.surface
        self.layer.cornerRadius = 10.0
        self.layer.applyMaterialShadow(elevation: 2)
        self.layer.masksToBounds = false
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(textLabel)
        addSubview(accessoryView)
        
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textLabel.rightAnchor.constraint(lessThanOrEqualTo: accessoryView.leftAnchor, constant: -10).isActive = true
        
        accessoryView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 56, height: 0)
        accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

class AccessoryView: UIView {
    
    var accessoryType: AccessoryType? {
        didSet {
            guard let _accessoryType = self.accessoryType else { return }
            
            // Remove all subview
            for subview in subviews {
                subview.removeFromSuperview()
            }
            
            // Set up views based on type
            switch _accessoryType {
            case .switch:
                // Set Switch
                self.setupSwitch()
                self.loadStateSwitchIsOn()
            case .disclosure:
                // Set icon Image
                self.setupIconImageView()
            case .none: ()
            }
        }
    }
    
    public var key: String!
    
    private let stateSwitch: UISwitch = {
        let s = UISwitch()
        s.onTintColor = UIColor.scheme.primary
        s.addTarget(self, action: #selector(valueChangedStateSwitch), for: .valueChanged)
        return s
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.scheme.icon
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImage(_ image: UIImage) {
        self.iconImageView.image = image
    }
    
    private func setupSwitch() {
        addSubview(stateSwitch)
        stateSwitch.centerInSuperView()
    }
    
    private func setupIconImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func loadStateSwitchIsOn() {
        if let isOn = UserDefaults.standard.object(forKey: self.key) as? Bool {
            self.stateSwitch.isOn = isOn
        }
    }
    
    private func saveStateSwitchIsOn() {
        let isOn = self.stateSwitch.isOn
        UserDefaults.standard.setValue(isOn, forKey: self.key)
    }
    
    @objc
    private func valueChangedStateSwitch(_ sender: UISwitch) {
        self.saveStateSwitchIsOn()
    }
}

protocol SettingsHeaderViewDelegate: class {
    func didBack()
}

class SettingsHeaderView: UICollectionReusableView {
    
    weak var delegate: SettingsHeaderViewDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.scheme.secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.scheme.button
        let image = UIImage(named: "back_large")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
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
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        backButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 56, height: 56)
        backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc
    private func handleBack() {
        self.delegate?.didBack()
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.padding / 2, bottom: self.padding, right: self.padding / 2)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : cellData[section - 1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        
        let section = indexPath.section
        let index = indexPath.item
        
        if section == 0 {
            return cell
        }
        
        cell.cellData = self.cellData[section - 1][index]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SettingsHeaderView
        headerView.delegate = self
        
        let section = indexPath.section
                
        let title = self.sectionTitles[section]
        headerView.titleLabel.text = title
        
        let textColor: UIColor = section == 0 ? UIColor.scheme.label : UIColor.scheme.secondaryLabel
        headerView.titleLabel.textColor = textColor
        
        let size: CGFloat = section == 0 ? 26 : 13
        let weight: UIFont.Weight = section == 0 ? .bold : .semibold
        headerView.titleLabel.font = UIFont.systemFont(ofSize: size, weight: weight)
        
        let alpha: CGFloat = section == 0 ? 1.0 : 0.0
        headerView.backButton.alpha = alpha
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = SettingsCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 2 * self.padding, height: 1000))
        
        // process
        
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: self.view.frame.width - 2 * self.padding, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        //return CGSize(width: self.view.frame.width - 2 * self.padding, height: estimatedSize.height)
        return CGSize(width: self.view.frame.width - 2 * self.padding, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = section == 0 ? 96 : 40
        return CGSize(width: self.view.frame.width, height: height)
    }
}

extension SettingsController: SettingsHeaderViewDelegate {
    
    func didBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
