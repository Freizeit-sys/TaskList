//
//  TaskCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

protocol TaskCellDelegate: class {
    func didCheck(complete: Bool)
    func didDeleteCell(_ cell: TaskCell)
}

class TaskCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    weak var delegate: TaskCellDelegate?
    
    var isCompleted: Bool = false {
        didSet {
            let imageName = self.isCompleted ? "check" : "uncheck"
            let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            completeButton.setImage(image, for: .normal)
            completeButton.tintColor = self.isCompleted ? .rgb(red: 46, green: 88, blue: 226) : .systemGray
        }
    }
    
    private var isFeedback: Bool = false
    
    private let cellContents: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.applyMaterialShadow(elevation: 4)
        return view
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemGray
        let image = UIImage(named: "uncheck")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8 , right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add More Content on Dribble Profile"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //let duedate:
    
    let archiveImageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.applyMaterialShadow(elevation: 2)
        view.layer.cornerRadius = 44 / 2
        view.layer.masksToBounds = false
        return view
    }()
    
    let archiveImageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "archive")?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        iv.tintColor = .rgb(red: 46, green: 88, blue: 226)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let panGesture: UIPanGestureRecognizer = {
        let pg = UIPanGestureRecognizer()
        pg.cancelsTouchesInView = false
        return pg
    }()
    
    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let point: CGPoint = panGesture.translation(in: self)
        let width = self.cellContents.frame.width
        let height  = self.cellContents.frame.height

        if panGesture.state == .changed {
            // Move cellContents
            if point.x < 0 {
                self.cellContents.frame = CGRect(x: point.x, y: 0, width: width, height: height)
            }

            // Feedback or animation archive image
            if point.x < -60 && !isFeedback {

                UIView.animate(withDuration: 0.2) {
                    self.archiveImageShadowView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                } completion: { (finished) in
                    UIView.animate(withDuration: 0.2) {
                        self.archiveImageShadowView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                }

                if let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
                    generator.impactOccurred()
                    isFeedback = true
                }
            }

            // Reset feedback or animation
            if point.x > -60 && isFeedback {
                isFeedback = false
            }
        }
        
        if panGesture.state == .ended {
            // Move cellContents
            if point.x < -65 {
                self.cellContents.frame = CGRect(x: -(width + 32), y: 0, width: width, height: height)
            } else {
                self.cellContents.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        }
    }
    
    private func commonInit() {
        self.addSubview(archiveImageShadowView)
        archiveImageShadowView.addSubview(archiveImageView)
        
        self.contentView.addSubview(cellContents)
        
        self.cellContents.addSubview(completeButton)
        self.cellContents.addSubview(titleLabel)
        self.cellContents.addGestureRecognizer(panGesture)
        
        //cellContents.frame = contentView.frame
        cellContents.fillSuperView()
        
        archiveImageShadowView.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 44, height: 44)
        archiveImageShadowView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        archiveImageView.fillSuperView(insets)
        
        completeButton.anchor(top: nil, left: self.cellContents.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        completeButton.centerYAnchor.constraint(equalTo: self.cellContents.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: self.cellContents.topAnchor, left: completeButton.rightAnchor, bottom: self.cellContents.bottomAnchor, right: self.cellContents.rightAnchor, paddingTop: 24, paddingLeft: 10, paddingBottom: 24, paddingRight: 48, width: 0, height: 0)
        
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
    }
    
    @objc private func handleComplete() {
        self.isCompleted = !self.isCompleted
        
        let imageName = self.isCompleted ? "check" : "uncheck"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        
        UIView.transition(with: self.completeButton.imageView!, duration: 0.3, options: .transitionCrossDissolve) {
            self.completeButton.imageView?.image = image
        } completion: { (finished) in
            //
            self.delegate?.didCheck(complete: self.isCompleted)
            // Delete cell
            self.archiveImageShadowView.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                self.cellContents.alpha = 0.0
            } completion: { (finished) in
                self.delegate?.didDeleteCell(self)
            }
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            ()
        case .changed:
            self.setNeedsLayout()
            //changed()
        case .ended:
            //ended()
            let point = gesture.translation(in: self)
            if point.x < -65 {
                // Delete cell
                UIView.animate(withDuration: 0.3) {
                    self.archiveImageShadowView.alpha = 0.0
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                } completion: { (finished) in
                    self.delegate?.didDeleteCell(self)
                }
            } else {
                // Stop deleting cell
                UIView.animate(withDuration: 0.3) {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
                isFeedback = false
            }
        default:
            ()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
    }
}

