//
//  ViewController+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 15/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

extension UIViewController  {
    
    func showAlert(withTitle title: String?,
                   message: String?,
                   buttonTitle: String?) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                    
                })
                return
            }
        }
        
        self.tabBarController?.tabBar.isHidden = hidden
        
        
        
//        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    func setupNavBar(isClear: Bool) {
        if isClear {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
        } else {
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.view.backgroundColor = UIColor.white
        }
    }
}
