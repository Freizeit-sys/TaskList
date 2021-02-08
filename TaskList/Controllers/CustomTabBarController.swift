//
//  CustomTabBarController.swift
//  TaskList
//
//  Created by Admin on 2021/02/06.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setValue(CustomTabBarA(frame: self.tabBar.frame), forKey: "tabBar")
        self.delegate = self
        
        setup()
        setupViewControllers()
        
        self.selectedIndex = 2
    }
    
    private func setup() {
        guard let customTabBar = self.tabBar as? CustomTabBarA else { return }
        
        // Remove border
        if #available(iOS 13.0, *) {
            let appearance = customTabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            customTabBar.standardAppearance = appearance
        } else { // iOS 12 and below:
            customTabBar.barTintColor = UIColor.systemBackground
            customTabBar.shadowImage = UIImage()
            customTabBar.backgroundImage = UIImage()
        }
        
        customTabBar.tintColor = UIColor.label
        customTabBar.unselectedItemTintColor = UIColor.label
        customTabBar.isTranslucent = false
        
        customTabBar.layer.applySketchShadow(color: .black, x: 0, y: -8, blur: 10, spread: 1)
        customTabBar.layer.masksToBounds = false
    }
    
    private func setupViewControllers() {
        let menuViewController = UIViewController()
        let menuNavController = templateNavController(rootViewController: menuViewController, image: (UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate))!)
        
        let taskListViewController = TaskListController()
        let taskListNavController = templateNavController(rootViewController: taskListViewController, image: UIImage())
        
        let space1 = UIViewController()
        let space2 = UIViewController()
        
        let optionsViewController = UIViewController()
        let optionsNavController = templateNavController(rootViewController: optionsViewController, image: (UIImage(named: "options")?.withRenderingMode(.alwaysTemplate))!)
        
        self.viewControllers = [menuNavController, space1, taskListNavController, space2, optionsNavController]
        
        // Modify tab bar image insets
        let items = tabBar.items ?? []
        //items.forEach { $0.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0) }
        items.forEach { $0.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0) }
    }
    
    fileprivate func templateNavController(rootViewController: UIViewController, image: UIImage) -> UINavigationController {
        let navController = CustomNavigationController(rootViewController: rootViewController, navigationBarClass: CustomNavigationBar.self, toolbarClass: nil)
        navController.navigationBar.barTintColor = .systemBackground
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = false
        
        // Remove border
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        
        navController.tabBarItem.image = image
        return navController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 0 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.systemBackground
            present(vc, animated: true, completion: nil)
        }
        
        if index == 4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.systemBackground
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        return index == 0 || index == 4 ? true : false
    }
}

class CustomTabBarA: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
