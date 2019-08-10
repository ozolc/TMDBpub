//
//  Results.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct ResultsMovie: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    
    let results: [Movie]
}
