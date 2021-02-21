//
//  TaskListMenuView.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

enum SortType: Int {
    case myOrder, date
}

extension UserDefaults {
    
    func setSortType(_ type: SortType?, forKey key: String) {
        set(type?.rawValue, forKey: key)
    }
    
    func getSortType(forKey key: String) -> SortType? {
        if let rawValue = object(forKey: key) as? Int {
            return SortType(rawValue: rawValue)
        }
        return nil
    }
}

class TaskListMenuView: UIView {
    
    var didSortList: ((SortType) -> ())?
    var didRenameList: ((String) -> ())?
    var didDeleteList: (() -> ())?
    
    private var sortType: SortType = .myOrder
    
    private let cellDatas: [[String]] = [["My order", "Date"], ["Rename list", "Delete list"]]
    
    private let margin: CGFloat = 0.0
    private let cellHeight: CGFloat = 48.0
    private let headerHeight: CGFloat = 40.0
    private let footerHeight: CGFloat = 1.0
    
    private var originalFrame: CGRect!
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let footerId = "footerId"
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 10
        cv.layer.applyMaterialShadow(elevation: 4)
        cv.layer.masksToBounds = false
        return cv
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let g = UITapGestureRecognizer()
        g.cancelsTouchesInView = false
        return g
    }()
    
    private let panGesture: UIPanGestureRecognizer = {
        let g = UIPanGestureRecognizer()
        g.cancelsTouchesInView = false
        return g
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadSortType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        overlayView.frame = self.frame
        self.addSubview(overlayView)
        
        let count = self.cellDatas.flatMap({ $0 }).count
        let cellsHeight: CGFloat = CGFloat(count) * cellHeight
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        
        let height: CGFloat = cellsHeight + headerHeight + bottomInset
        
        collectionView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        
        collectionView.register(TaskListMenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TaskListMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(TaskListMenuFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        
        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        collectionView.addGestureRecognizer(panGesture)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.overlayView.alpha = 1.0
            self.collectionView.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        }, completion: nil)
        
        self.originalFrame = collectionView.frame
    }
    
    private func loadSortType() {
        guard let sortType = UserDefaults.standard.getSortType(forKey: "sortType") else {
            return
        }
        self.sortType = sortType
    }
    
    private func saveSortType() {
        UserDefaults.standard.setSortType(self.sortType, forKey: "sortType")
    }
    
    private func dismiss() {
        let height: CGFloat = self.originalFrame.height
    
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0.0
            self.collectionView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: height)
        } completion: { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        self.dismiss()
    }
    
    @objc
    private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        
        switch recognizer.state {
        case .changed:
            // Top limit
            guard collectionView.frame.minY > 0 else { return }
            
            let y = originalFrame.minY + translation.y * 0.6
            let height = originalFrame.height + -translation.y * 0.6
            collectionView.frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: height)
        case .ended:
            if translation.y > 30 {
                // Dismiss view
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
                    self.collectionView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.originalFrame.height)
                } completion: { (finished) in
                    self.removeFromSuperview()
                }
            } else {
                // Set back to position
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.collectionView.frame = self.originalFrame
                }, completion: nil)
            }
        default: break
        }
    }
}

extension TaskListMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.cellDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellDatas[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskListMenuCell
        
        let section = indexPath.section
        cell.cellType = section == 0 ? .radio : .normal
        
        let text = cellDatas[section][indexPath.item]
        cell.textLabel.text = text
        
        if sortType == .myOrder && indexPath.item == 0 {
            cell.toggleRadioButton()
        }
        
        if sortType == .date && indexPath.item == 1 {
            cell.toggleRadioButton()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! TaskListMenuHeaderView
            return headerView
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath)
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .init(width: frame.width, height: self.headerHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return .init(width: frame.width, height: self.footerHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.item
        
        let previousIndex = index == 0 ? 1 : 0
        let previousIndexPath = IndexPath(item: previousIndex, section: 0)
        let previousCell = collectionView.cellForItem(at: previousIndexPath) as! TaskListMenuCell
        
        let cell = collectionView.cellForItem(at: indexPath) as! TaskListMenuCell
        
        switch section {
        case 0:
            // Deselect previous cell
            previousCell.toggleRadioButton()
            // Select cell
            cell.toggleRadioButton()
            
            // Sorting the list
            self.sortType = index == 0 ? .myOrder : .date
            self.didSortList?(self.sortType)
            self.saveSortType()
        case 1: ()
            if index == 0 {
                // Rename the list
                self.didRenameList?("title")
            } else {
                // Delete the list
                self.didDeleteList?()
            }
        default:
            break
        }
        
        self.dismiss()
    }
}
