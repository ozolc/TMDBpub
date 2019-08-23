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
        
        APIService.shared.setGlobalUserFromKeychain()
        
        APIService.shared.loadingGenresFromNet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if self.isUserSignedIn() {
                    
                    APIService.shared.loadingUserDataFromNet(completion: {
                        APIService.shared.setGlobalUserFromKeychain()
                        AppDelegate.shared.rootViewController.switchToMainScreen()
                    })
                    
                } else {
                    AppDelegate.shared.rootViewController.switchToLogout()
                    print("No user in Keychain")
                }
            }
        }
        
    }
    
    func isUserSignedIn() -> Bool {
        return authManager.isUserSignedIn()
    }
    
    func signOutCurrentUser() {
        authManager.deleteCurrentUser()
    }
}
