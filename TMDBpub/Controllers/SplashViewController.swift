//
//  SplashViewController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 20/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var authManager = AuthenticationManager()
    
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
        
        APIService.shared.setFromAuthManagedData()
        
//        Constants.apiKey = authManager.apiKey
//        Constants.sessionId = authManager.userCredentials?.sessionId ?? "nil"
//        Constants.accountId = authManager.userCredentials?.accountId ?? "nil"
//
//        print("Session ID =", Constants.sessionId)
//        print("API Key =", Constants.apiKey)
//        print("Account ID =", Constants.accountId)
//        print("User is signed - ", self.isUserSignedIn())
        
        APIService.shared.loadingGenresFromNet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if self.isUserSignedIn() {
                    
                    APIService.shared.loadingUserDataFromNet(completion: {
                        APIService.shared.setFromAuthManagedData()
                        AppDelegate.shared.rootViewController.switchToMainScreen()
                    })
                    
                } else {
                    AppDelegate.shared.rootViewController.switchToLogout()
                    print("No user in Keychain")
                }
            }
        }
        
    }
    
//    func loadingUserDataFromNet(completion: @escaping () -> ()) {
//
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//
//        APIService.shared.fetchMoviesStat(typeOfRequest: Constants.Account, sessionId:  Constants.sessionId, completionHandler: { (user: User) in
//            dispatchGroup.leave()
//            globalUser = user
//        })
//
//        dispatchGroup.notify(queue: .main) {
//            completion()
//        }
//    }
    
//    func loadingGenresFromNet(completion: @escaping () -> ()) {
//        let infoAboutGenre = Constants.infoAboutGenre
//
//        APIService.shared.fetchMoviesStat(typeOfRequest: infoAboutGenre, language: Constants.language, completionHandler: { (genre: Genre) in
//            genresArray += genre.genres
//
//        })
//        print("Genres successfully downloaded genres from net")
//        completion()
//    }
    
    func isUserSignedIn() -> Bool {
        return authManager.isUserSignedIn()
    }
    
    func signOutCurrentUser() {
        authManager.deleteCurrentUser()
    }
}
