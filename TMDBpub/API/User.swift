//
//  User.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct User: Codable {
    let avatar: Avatar
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String?
}

struct Avatar: Codable {
    let gravatar: Gravatar
}

struct Gravatar: Codable {
    let hash: String
}
