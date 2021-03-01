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
    
    static let blueGray = UIColor.rgb(red: 242, green: 246, blue: 254)
    static let chacoalBlack = UIColor.rgb(red: 31, green: 33, blue: 39)
    static let noirBlack = UIColor.rgb(red: 42, green: 46, blue: 59)
    static let mainBlue = UIColor.rgb(red: 46, green: 88, blue: 226)
    static let mainNavy = UIColor.rgb(red: 115, green: 76, blue: 246)
    static let lightGreen = UIColor.rgb(red: 0, green: 230, blue: 118)
    static let darkGreen = UIColor.rgb(red: 102, green: 187, blue: 106)
    static let lightRed = UIColor.rgb(red: 229, green: 115, blue: 115)
    static let darkRed = UIColor.rgb(red: 239, green: 83, blue: 80)
    
    struct scheme {
        public static let primary = UIColor.primary
        public static let background = UIColor.background
        public static let secondaryBackground = UIColor.secondaryBackground
        public static let surface = UIColor.surface
        public static let label = UIColor.label
        public static let secondaryLabel = UIColor.secondaryLabel
        public static let check = UIColor.check
        public static let remove = UIColor.remove
        public static let icon = UIColor.icon
        public static let button = UIColor.button
        public static let control = UIColor.control
        public static let line = UIColor.line
        public static let ink = UIColor.ink
        public static let error = UIColor.error
    }
    
    static private var primary: UIColor {
        guard #available(iOS 13.0, *) else  {
            return mainBlue
        }
        
        let color = UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return mainNavy
            } else {
                return mainBlue
            }
        }
        
        return color
    }
    
    static private var background: UIColor {
        guard #available(iOS 13.0, *) else  {
            return blueGray
        }
        
        let color = UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return chacoalBlack
            } else {
                return blueGray
            }
        }
        
        return color
    }
    
    static private var secondaryBackground: UIColor {
        guard #available(iOS 13.0, *) else  {
            return .white
        }
        
        let color = UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return chacoalBlack
            } else {
                return .white
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
                return .noirBlack
            } else {
                return .white
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
    
    static private var check: UIColor {
        guard #available(iOS 13.0, *) else {
            return .darkGreen
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .lightGreen
            } else {
                return .darkGreen
            }
        }
        
        return color
    }
    
    static private var remove: UIColor {
        guard #available(iOS 13.0, *) else {
            return .darkRed
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .lightRed
            } else {
                return .darkRed
            }
        }
        
        return color
    }
    
    static private var icon: UIColor {
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
    
    static private var control: UIColor {
        guard #available(iOS 13.0, *) else {
            return .rgb(red: 145, green: 251, blue: 175)
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .rgb(red: 145, green: 251, blue: 175)
            } else {
                return .rgb(red: 145, green: 251, blue: 175)
            }
        }
        
        return color
    }
    
    static private var line: UIColor {
        guard #available(iOS 13.0, *) else {
            return .rgb(red: 229, green: 229, blue: 234)
        }
        
        let color = UIColor { (traitCollction) -> UIColor in
            if traitCollction.userInterfaceStyle == .dark {
                return .rgb(red: 64, green: 64, blue: 64)
            } else {
                return .rgb(red: 229, green: 229, blue: 234)
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
