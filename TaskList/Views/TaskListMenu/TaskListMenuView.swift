//
//  TaskListMenuView.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

class TaskListMenuView: UIView {
    
    private let itemCount: Int = 4
    
    private let margin: CGFloat = 0.0
    private let padding: CGFloat = 8.0
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        overlayView.frame = self.frame
        self.addSubview(overlayView)
        
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        let cellsHeight: CGFloat = CGFloat(itemCount) * cellHeight
        let height: CGFloat = cellsHeight + headerHeight + (padding * 2) + bottomInset
        collectionView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        collectionView.register(TaskListMenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TaskListMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return self.itemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskListMenuCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! TaskListMenuHeaderView
        return headerView
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
}






class TaskListMenuCell: UICollectionViewCell {
    
    private let radioButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.tintColor = .black
        //button.alpha = 0.0
        button.isEnabled = false
        return button
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "text text"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(radioButton)
        addSubview(textLabel)
        
        radioButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        radioButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel.anchor(top: topAnchor, left: radioButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
    }
}


class TaskListMenuHeaderView: UICollectionReusableView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Sort by"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        addSubview(label)
        label.fillSuperView(.init(top: 0, left: 24, bottom: 0, right: 0))
    }
}
