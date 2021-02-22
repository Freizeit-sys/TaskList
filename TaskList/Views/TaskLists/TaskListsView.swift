//
//  TaskListsView.swift
//  TaskList
//
//  Created by Admin on 2021/02/20.
//

import UIKit

protocol TaskListsViewDelegate: class {
    func didBack()
}

class TaskListsView: UIView {
    
    weak var delegate: TaskListsViewDelegate?
    
    var datasource: TaskListsDataSource!
    
    var didCreateTaskList: (() -> ())?
    var didChangeTaskList: ((String, Int) -> ())?
    
    private let margin: CGFloat = 0.0
    private let padding: CGFloat = 8.0
    private let cellHeight: CGFloat = 48.0
    private let footerHeight: CGFloat = 48.0
    
    private var originalFrame: CGRect!
    
    private let cellId = "cellId"
    private let footerId = "footerId"
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.scheme.background
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupViews() {
        overlayView.frame = self.frame
        self.addSubview(overlayView)
        
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        let cellCount: CGFloat = CGFloat(self.datasource.countTaskList())
        let height: CGFloat = (cellCount * cellHeight) + footerHeight + (padding * 2) + bottomInset
        collectionView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        collectionView.register(TaskListsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TaskListsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
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

extension TaskListsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding, left: 0, bottom: padding, right: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.countTaskList()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskListsCell
        
        let taskList = self.datasource.taskList(at: indexPath.item)
        cell.taskList = taskList
        
        let isSelected = self.datasource.isSelectedTaskList(at: indexPath.item)
        
        if isSelected {
            cell.selectedView.alpha = 0.2
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as! TaskListsFooterView
        footerView.delegate = self
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.frame.width, height: self.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: self.frame.width, height: self.footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTaskList = self.datasource.selectedTaskList()
        self.didChangeTaskList?(selectedTaskList.title, indexPath.item)
        self.dismiss()
    }
}

extension TaskListsView: TaskListsFooterViewDelegate {
    
    func didCreateNewList() {
        let height: CGFloat = collectionView.contentSize.height
    
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0.0
            self.collectionView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: height)
        } completion: { (finished) in
            self.removeFromSuperview()
            
            
            self.didCreateTaskList?()
        }
    }
}
