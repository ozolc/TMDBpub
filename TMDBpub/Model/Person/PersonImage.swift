//
//  PersonImage.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 28/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct PersonImage: Codable {
    let id: Int
    let profiles: [ImageStruct]
}

struct ImageStruct: Codable {
    let width: Int?
    let height: Int?
    let vote_count: Int?
    let vote_average: Double?
    let file_path: String?
    let aspect_ratio: Double?
}
