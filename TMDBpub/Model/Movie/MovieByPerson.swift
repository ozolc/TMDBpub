//
//  MovieByPerson.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 01/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct MovieByPerson: Codable {
    let id: Int
    let cast: [Movie]
}
