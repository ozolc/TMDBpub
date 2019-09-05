//
//  MainTabBarController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 09/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let user = APIService.shared
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: TodayController(), title: "Today", image: #imageLiteral(resourceName: "popular").withRenderingMode(.alwaysTemplate)),
            
//            generateNavigationController(for: SearchPeopleController(), title: "Поиск", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)),
            
//            generateNavigationController(for: PersonController(personId: 2037), title: "Person", image: #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysTemplate)),
//            generateNavigationController(for: TestViewController(), title: "Rating", image: #imageLiteral(resourceName: "popular").withRenderingMode(.alwaysTemplate)),
            generateNavigationController(for: SearchGeneralController(), title: "Search", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)),
//            generateNavigationController(for: MovieDetailController(movieId: 414044), title: "Detail", image:  #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysTemplate)),
            generateNavigationController(for: GenericMoviesControllers(typeOfRequest: Constants.popularMovies), title: "Популярные", image: #imageLiteral(resourceName: "popular").withRenderingMode(.alwaysTemplate)),
//            generateNavigationController(for: SearchMovieController(), title: "Поиск", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)),
            generateNavigationController(for: AccountTableViewController(), title: "Profile", image: #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysTemplate)),
        ]
        
        let statusBarCover = UIView()
        statusBarCover.backgroundColor = .clear
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        let imgBack = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        navigationItem.leftItemsSupplementBackButton = true
    }

        
    //MARK: - Helper Functions
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationItem.hidesBackButton = true
        navController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return navController
    }
    
    
}

