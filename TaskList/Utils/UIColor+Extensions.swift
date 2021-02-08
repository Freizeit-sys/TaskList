//
//  UIColor+Extensions.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    struct scheme {
        public static let background = UIColor.background
        public static let surface = UIColor.surface
        public static let label = UIColor.label
        public static let secondaryLabel = UIColor.secondaryLabel
        public static let button = UIColor.button
        public static let ink = UIColor.ink
        public static let error = UIColor.error
    }
    
    static private var background: UIColor {
        guard #available(iOS 13.0, *) else {
            return rgb(red: 242, green: 242, blue: 247, alpha: 1.0)
        }
        
        let color = UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return tertiarySystemBackground
            } else {
                return secondarySystemBackground
            }
        }
        
        return color
    }
    
    static private var surface: UIColor {
        guard #available(iOS 13.0, *) else {
            return .white
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .secondarySystemBackground
            } else {
                return .systemBackground
            }
        }
        
        return color
    }
    
    static private var label: UIColor {
        guard #available(iOS 13.0, *) else {
            return .black
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
        
        return color
    }
    
    static private var secondaryLabel: UIColor {
        guard #available(iOS 13.0, *) else {
            return .darkGray
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .lightGray
            } else {
                return .darkGray
            }
        }
        
        return color
    }
    
    static private var button: UIColor {
        guard #available(iOS 13.0, *) else {
            return .darkGray
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .lightGray
            } else {
                return .darkGray
            }
        }
        
        return color
    }
    
    static private var ink: UIColor {
        guard #available(iOS 13.0, *) else {
            return UIColor(white: 0.0, alpha: 0.14)
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return UIColor(white: 1.0, alpha: 0.14)
            } else {
                return UIColor(white: 0.0, alpha: 0.14)
            }
        }
        
        return color
    }
    
    static private var error: UIColor {
        guard #available(iOS 13.0, *) else {
            return .rgb(red: 161, green: 32, blue: 39, alpha: 1.0)
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .rgb(red: 227, green: 133, blue: 169, alpha: 1.0)
            } else {
                return .rgb(red: 161, green: 32, blue: 39, alpha: 1.0)
            }
        }
        
        return color
    }
}
