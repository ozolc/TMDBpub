//
//  MainTabBarController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 09/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: PopularMoviesControllers(), title: "Popular", image: #imageLiteral(resourceName: "Popular").withRenderingMode(.alwaysOriginal))
        ]
    }
    
    //MARK: - Helper Functions
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
}
