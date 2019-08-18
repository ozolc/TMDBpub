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
            generateNavigationController(for: GenericMoviesControllers(typeOfRequest: Constants.popularMovies), title: "Популярные", image: #imageLiteral(resourceName: "popular").withRenderingMode(.alwaysOriginal)),
            generateNavigationController(for: SearchMovieController(), title: "Поиск", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal))
        ]
        
        let statusBarCover = UIView()
        statusBarCover.backgroundColor = .clear
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
    }
    
    //MARK: - Helper Functions
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationItem.hidesBackButton = true
        
        return navController
    }
    
    
}
