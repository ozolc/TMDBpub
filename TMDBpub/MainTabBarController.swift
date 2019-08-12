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

//        DispatchQueue.background(delay: 3.0, background: {
//            self.getGenresArray()
//        }) {
//            genresArray.forEach( { print($0.name)})
//        }
//    }
    
    func getGenresArray() {
        let infoAboutGenre = Constants.infoAboutGenre
        LoaderController.sharedInstance.showLoader()
        APIService.shared.fetchMoviesStat(typeOfRequest: infoAboutGenre, completionHandler: { (genre: Genre) in
            genresArray += genre.genres
            
                LoaderController.sharedInstance.removeLoader()
        })
    }
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: SearchMovieController(), title: "Search", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal)),
            generateNavigationController(for: PopularMoviesControllers(typeOfRequest: Constants.popularMovies), title: "Popular", image: #imageLiteral(resourceName: "Popular").withRenderingMode(.alwaysOriginal)),
        ]
        
//        getGenresArray()
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
