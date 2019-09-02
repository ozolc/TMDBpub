//
//  UIApplication+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 13/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

extension UIApplication {
    static func rootViewController() -> RootViewController? {
        return shared.keyWindow?.rootViewController as? RootViewController
    }
    
}
