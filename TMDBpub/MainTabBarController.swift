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
            generateNavigationController(for: GenericMoviesControllers(typeOfRequest: Constants.popularMovies), title: "Популярные", image: #imageLiteral(resourceName: "popular").withRenderingMode(.alwaysTemplate)),
            generateNavigationController(for: SearchMovieController(), title: "Поиск", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate))
        ]
        
        let statusBarCover = UIView()
        statusBarCover.backgroundColor = .clear
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        let imgBack = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        navigationItem.leftItemsSupplementBackButton = true
//        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
//        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
//        navigationItem.setLeftBarButton(logoutButton, animated: true)
        
    }

        
    //MARK: - Helper Functions
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationItem.hidesBackButton = true
//        navController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return navController
    }
    
    
}

