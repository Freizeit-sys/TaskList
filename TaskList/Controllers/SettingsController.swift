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
    
    private enum Section: Int, CaseIterable {
        case header, general, appIcons, themes, contact
        
        var sectionTitle: String {
            switch self {
            case .header:
                return "Settings"
            case .general:
                return "GENERAL"
            case .appIcons:
                return "APP ICON"
            case.themes:
                return "THEME"
            case .contact:
                return "CONTACT"
            }
        }
    }
    
    private let cellData: [[(text: String, type: AccessoryType)]] = [
        [(text: "Notifications", type: .switch)],
        [(text: "icon1", type: .none)],
        [(text: "theme1", type: .none)],
        [(text: "Write a Review", type: .disclosure), (text: "Help & Feedback", type: .disclosure)]
    ]
    
    private let padding: CGFloat = 16.0
    
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"
    private let headerId = "headerId"
    
    private let v = SettingsView()
    
    override func loadView() {
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.v.backgroundColor = UIColor.scheme.secondaryBackground
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.v.collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        self.v.collectionView.register(AppIconsCell.self, forCellWithReuseIdentifier: cellId2)
        self.v.collectionView.register(ThemesCell.self, forCellWithReuseIdentifier: cellId3)
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
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .general, .appIcons, .themes:
            return 1
        case .contact:
            return 2
        case .header, .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .general:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
            cell.cellData = self.cellData[indexPath.section - 1][indexPath.item]
            return cell
            
        case .appIcons:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! AppIconsCell
            return cell
            
        case .themes:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ThemesCell
            return cell
            
        case .contact:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
            cell.cellData = self.cellData[indexPath.section - 1][indexPath.item]
            return cell
            
        case .header, .none:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SettingsHeaderView
        headerView.delegate = self
        
        let section = indexPath.section
        
        let title = Section(rawValue: indexPath.section)?.sectionTitle
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
        switch Section(rawValue: indexPath.section) {
        case .general, .contact:
            return CGSize(width: self.view.frame.width - 2 * self.padding, height: 56)
        case .appIcons:
            return CGSize(width: self.view.frame.width - 2 * self.padding, height: 80)
        case .themes:
            return CGSize(width: self.view.frame.width - 2 * self.padding, height: 96)
        case .header, .none:
            return .zero
        }
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

class AppIconsCell: UICollectionViewCell {
    
    private let appIconNames = ["defaultIcon", "Icon1", "Icon2", "Icon3", "Icon4"]
    
    private let padding: CGFloat = 16.0
    private let cellId = "cellId"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.scheme.surface
        self.layer.cornerRadius = 10.0
        self.layer.applyMaterialShadow(elevation: 2)
        self.layer.masksToBounds = false
        
        addSubview(collectionView)
        
        collectionView.fillSuperView()
        
        collectionView.register(AppIconCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeAppIcon(_ appIconName: String? = nil) {
        UIApplication.shared.setAlternateIconName(appIconName) { (error) in
            print("Failed to changed App Icon.")
        }
    }
}

extension AppIconsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appIconName = appIconNames[indexPath.item]
        self.changeAppIcon(indexPath.item == 0 ? nil : appIconName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: self.padding, bottom: 0, right: self.padding)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appIconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppIconCell
        cell.appIconName = appIconNames[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (frame.width - 2 * padding) / 6
        return CGSize(width: width, height: width)
    }
}


class AppIconCell: UICollectionViewCell {
    
    var appIconName: String? {
        didSet {
            guard let _appIconName = self.appIconName else { return }
            
            let image = UIImage(named: _appIconName)?.withRenderingMode(.alwaysOriginal)
            appIconImageView.image = image
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.scheme.surface
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.scheme.line.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.scheme.background
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(containerView)
        containerView.addSubview(appIconImageView)
        
        containerView.fillSuperView()
        appIconImageView.fillSuperView(UIEdgeInsets(top: 1, left: 1, bottom: -1, right: -1))
        
        containerView.layer.cornerRadius = 15
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.containerView.layer.borderColor = UIColor.scheme.line.cgColor
    }
}

class ThemesCell: UICollectionViewCell {
    
    private let themeNames: [String] = ["Theme1", "Theme2", "Theme3", "Theme4", "Theme5"]
    
    private let padding: CGFloat = 16.0
    private let cellId = "cellId"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.scheme.surface
        self.layer.cornerRadius = 10.0
        self.layer.applyMaterialShadow(elevation: 2)
        self.layer.masksToBounds = false
        
        addSubview(collectionView)
        
        collectionView.fillSuperView()
        
        collectionView.register(ThemeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ThemesCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: self.padding, bottom: 8, right: self.padding)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.themeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ThemeCell
        cell.themeName = themeNames[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - 2 * self.padding) / 6
        let height = frame.height - padding
        return CGSize(width: width, height: height)
    }
}

class ThemeCell: UICollectionViewCell {
    
    var themeName: String? {
        didSet {
            guard let _themeName = self.themeName else { return }
            
            let image = UIImage(named: _themeName)?.withRenderingMode(.alwaysOriginal)
            themeIconImageView.image = image
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let themeIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.scheme.background
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(containerView)
        containerView.addSubview(themeIconImageView)
        
        containerView.fillSuperView()
        themeIconImageView.fillSuperView()
        
        let rotationAngle: CGFloat = CGFloat(350 * Double.pi / 180)
        containerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        containerView.layer.cornerRadius = 8
    }
}
