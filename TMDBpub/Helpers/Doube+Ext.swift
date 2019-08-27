//
//  Doube+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 27/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

extension Double {
    
    func truncate(to places: Int) -> Double {
        return Double(Int((pow(10, Double(places)) * self).rounded())) / pow(10, Double(places))
    }
    
}
