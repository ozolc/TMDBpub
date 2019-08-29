//
//  MovieImage.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 29/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct MovieImage: Codable {
    let id: Int
    let backdrops: [ImageStruct]
    let posters: [ImageStruct]
}
