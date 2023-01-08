//
//  MainViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import UIKit

final class MainViewController: UITabBarController {
    
    //MARK: Property
    private var gitNavigationController: GCMNavigationViewController!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setViewControllers()
        setupTabBar()
    }
    
}


extension MainViewController {
    
    private func setViewControllers() {
        
        /// SearchViewController 화면 📺
        let searchViewController = PostDIContainer().makeViewController()
        
        gitNavigationController = GCMNavigationViewController(
            rootViewController: searchViewController
        )
        
        gitNavigationController?.tabBarItem = .init(
            title: "main.tabItem.home".localized(),
            image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "home_active")?.withRenderingMode(.alwaysOriginal)
        )
        
        
        self.viewControllers = [
            gitNavigationController
        ]
        
    }
    
    
    private func setupTabBar() {
        let tabbarAppearance = UITabBarAppearance()
        
        tabbarAppearance.backgroundColor = .white
        
        
        tabbarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont.semiBold(size: 12),
            .foregroundColor: UIColor.gitLightGray!
        ]
        
        self.tabBar.standardAppearance = tabbarAppearance
        
        self.tabBar.tintColor = .gitLightGray
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.white.cgColor
        
        
        
        
    }
    
}
