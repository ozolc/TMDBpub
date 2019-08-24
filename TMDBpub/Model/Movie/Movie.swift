//
//  Movie.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let id: Int
    let vote_average: Double
    let vote_count: Int
    let title: String
    let popularity: Double
    let poster_path: String?
    let original_title: String
    let backdrop_path: String?
    let overview: String?
    let release_date: String
    let runtime: Int?
    let production_countries: [Country]?
    let genres: [GenreStruct]?
    let production_companies: [ProductionCompany]?
    let genre_ids: [Int]?
    let adult: Bool?
    let video: Bool?
    
}
