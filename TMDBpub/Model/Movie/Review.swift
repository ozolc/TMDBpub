//
//  Review.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct Review: Codable {
    let id: Int
    let page: Int
    let results: [ReviewResult]
    let total_pages: Int
    let total_results: Int
}

struct ReviewResult: Codable {
    let author: String
    let content: String
    let id: String
    let url: String
}
