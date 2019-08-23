//
//  MovieState.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 23/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct MovieState: Codable {
    let id: Int
    let favorite: Bool
    let watchlist: Bool
}
