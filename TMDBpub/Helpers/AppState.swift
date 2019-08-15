//
//  AppState.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 15/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

class AppState {
    
    static let shared = AppState()
    
    var currentPage: Int = 1
    var totalPages: Int = 0
    
    func resetPageDetails() {
        currentPage = 1
        totalPages = 0
    }
}
