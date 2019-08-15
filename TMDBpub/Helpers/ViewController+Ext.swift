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
}
