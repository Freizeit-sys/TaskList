//
//  CalendarPickerView.swift
//  TaskList
//
//  Created by Admin on 2021/02/21.
//

import UIKit

class CalendarPickerView: UIView {
    
    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: effect)
        vev.alpha = 0.0
        return vev
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let g = UITapGestureRecognizer()
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
        addSubview(blurView)
        blurView.frame = self.frame
                
        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        blurView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.blurView.alpha = 1.0
        }, completion: nil)
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.blurView.alpha = 0.0
        } completion: { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        self.dismiss()
    }
}
