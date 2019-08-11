//
//  Int+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 11/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

extension Int {
    
    func toTime() -> String {
        let minutes = self % 60
        let hours = self / 60
        let timeFormatString = String(format: "%02d:%02d", hours, minutes)
        return timeFormatString
    }
}
