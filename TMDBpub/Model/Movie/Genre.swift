//
//  Genre.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let genres: [GenreStruct]
}

struct GenreStruct: Codable {
    let id: Int
    let name: String
}
