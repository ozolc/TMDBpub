//
//  SplashViewController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 20/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

//protocol SplashViewControllerDelegate: class {
//    func deleteKeychainData()
//}

class SplashViewController: UIViewController {
    
    private var authManager = AuthenticationManager()
    
//    weak var delegate: SplashViewControllerDelegate!
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        view.addSubview(activityIndicator)
        
        setBackgroundImage()
        
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        makeServiceCall()
    }
    
    fileprivate func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "pattern")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func makeServiceCall() { 
        activityIndicator.startAnimating()
        
        Constants.apiKey = authManager.apiKey
        print(Constants.apiKey)
        
        loadingGenresFromNet {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if self.isUserSignedIn() {
                    AppDelegate.shared.rootViewController.switchToMainScreen()
                } else {
//                    self.signOutCurrentUser()
                    AppDelegate.shared.rootViewController.switchToLogout()
                    print("No user in Keychain")
                }
            }
        }
        
    }
    
    func loadingGenresFromNet(completion: @escaping () -> ()) {
        let infoAboutGenre = Constants.infoAboutGenre
        APIService.shared.fetchMoviesStat(typeOfRequest: infoAboutGenre, language: Constants.language, completionHandler: { (genre: Genre) in
            genresArray += genre.genres
            
            completion()
        })
    }
    
    func isUserSignedIn() -> Bool {
        return authManager.isUserSignedIn()
    }
    
    func signOutCurrentUser() {
        authManager.deleteCurrentUser()
    }
}
