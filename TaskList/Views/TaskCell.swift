//
//  TaskCell.swift
//  TaskList
//
//  Created by Admin on 2021/02/08.
//

import UIKit

protocol TaskCellDelegate: class {
    func didComplete(_ cell: TaskCell)
    func didDeleteCell(_ cell: TaskCell)
}

class TaskCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    weak var delegate: TaskCellDelegate?
    
    private var isFeedback: Bool = false
    
    var task: Task? {
        didSet {
            guard let _task = task else { return }
            titleLabel.text = _task.title
            
            let title = _task.title
            let duedate = _task.duedate.string(format: "yyyy-MM-dd HH:mm")
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4.0
            
            let attributed1: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.scheme.label,
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            ]
            
            let attributed2: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.scheme.secondaryLabel,
                .font: UIFont.systemFont(ofSize: 13, weight: .regular)
            ]
            
            let attributedText = NSMutableAttributedString(string: title, attributes: attributed1)
            attributedText.append(NSAttributedString(string: "\n" + duedate, attributes: attributed2))
            titleLabel.attributedText = attributedText
            
            let isCompleted = _task.completed
            let imageName = isCompleted ? "checked" : "unchecked"
            let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            completeButton.setImage(image, for: .normal)
            completeButton.tintColor = isCompleted ? UIColor.scheme.check : .systemGray
        }
    }
    
    private let cellContents: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.scheme.surface
        view.alpha = 1.0
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.applyMaterialShadow(elevation: 4)
        return view
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.scheme.check
        let image = UIImage(named: "unchecked")?.withRenderingMode(.alwaysTemplate)
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
        label.textColor = UIColor.scheme.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let archiveImageView: UIView = {
        let view = ArchiveImageView()
        view.backgroundColor = UIColor.scheme.surface
        view.alpha = 1.0
        return view
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
                    self.archiveImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                } completion: { (finished) in
                    UIView.animate(withDuration: 0.2) {
                        self.archiveImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
        addSubview(archiveImageView)
        
        contentView.addSubview(cellContents)
        
        cellContents.addSubview(completeButton)
        cellContents.addSubview(titleLabel)
        cellContents.addGestureRecognizer(panGesture)
        
        cellContents.fillSuperView()
        
        archiveImageView.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 44, height: 44)
        archiveImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        completeButton.anchor(top: nil, left: self.cellContents.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        completeButton.centerYAnchor.constraint(equalTo: self.cellContents.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: self.cellContents.topAnchor, left: completeButton.rightAnchor, bottom: self.cellContents.bottomAnchor, right: self.cellContents.rightAnchor, paddingTop: 24, paddingLeft: 10, paddingBottom: 24, paddingRight: 48, width: 0, height: 0)
        
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
    }
    
    private func changeCheckButtonImage(_ isCompleted: Bool, completion: @escaping() -> ()) {
        UIView.animate(withDuration: 0.3) {
            self.completeButton.alpha = 0.0
        } completion: { (finished) in
            // Change image and image color
            self.task?.completed.toggle()
            
            UIView.animate(withDuration: 0.3) {
                self.completeButton.alpha = 1.0
            } completion: { (finished) in
                completion()
            }
        }
    }
    
    private func animateDeleteCell() {
        UIView.animate(withDuration: 0.3) {
            self.cellContents.alpha = 0.0
        } completion: { (finished) in
            self.delegate?.didDeleteCell(self)
        }
    }
    
    @objc
    private func handleComplete() {
        completeButton.isUserInteractionEnabled = false
        guard let isCompleted = self.task?.completed else { return print("Failed to find task.") }
        self.changeCheckButtonImage(isCompleted) {
            self.completeButton.isUserInteractionEnabled = true
            self.delegate?.didComplete(self)
        }
    }
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            ()
        case .changed:
            self.setNeedsLayout()
        case .ended:
            let point = gesture.translation(in: self)
            if point.x < -65 {
                // Delete cell
                UIView.animate(withDuration: 0.3) {
                    self.archiveImageView.alpha = 0.0
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset position and alpha
        let frame = cellContents.frame
        cellContents.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        cellContents.alpha = 1.0
        archiveImageView.alpha = 1.0
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
    }
}
