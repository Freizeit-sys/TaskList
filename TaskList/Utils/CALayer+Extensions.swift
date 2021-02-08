//
//  CALayer+Extensions.swift
//  TaskList
//
//  Created by Admin on 2021/02/06.
//

import UIKit

extension CALayer {
    
    func applyMaterialShadow(elevation: CGFloat) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: elevation)
        shadowRadius = CGFloat(elevation)
        shadowOpacity = 0.24
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0.0, y: CGFloat = 0.0, blur: CGFloat = 0.0, spread: CGFloat = 0.0) {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        shadowOpacity = alpha
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
