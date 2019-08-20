//
//  AppDelegate.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 09/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}

var genresArray = [GenreStruct]()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
//        window?.rootViewController = MainTabBarController()
        window?.rootViewController = RootViewController()
//        let navController = UINavigationController(rootViewController: LoginController())
//        window?.rootViewController = navController
        
        
        let navigationBarAppearnce = UINavigationBar.appearance()
//        navigationBarAppearnce.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        
        navigationBarAppearnce.tintColor = #colorLiteral(red: 0.2304878831, green: 0.3483577371, blue: 0.5966511965, alpha: 1)
        navigationBarAppearnce.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2304878831, green: 0.3483577371, blue: 0.5966511965, alpha: 1)]
        
        let tabBarAppearnce = UITabBar.appearance()
        tabBarAppearnce.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        tabBarAppearnce.tintColor = #colorLiteral(red: 0.2304878831, green: 0.3483577371, blue: 0.5966511965, alpha: 1) // Change selected icon color
        UITabBar.appearance().unselectedItemTintColor =  .gray
        navigationBarAppearnce.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2304878831, green: 0.3483577371, blue: 0.5966511965, alpha: 1)]
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

