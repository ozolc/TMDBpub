//
//  Person.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 26/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct Person: Codable {
    let birthday: String?
    let knownForDepartment: String?
    let deathday: String?
    let id: Int
    let name: String
    let alsoKnownAs: [String]?
    let biography: String
    let popularity: Double
    let place_of_birth: String?
    let profile_path: String?
    let adult: Bool
    let imdb_id: String
    let homepage: String?
}
