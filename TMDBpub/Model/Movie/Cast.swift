//
//  Cast.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct Cast: Codable {
    let id: Int
    let cast: [CastResult]
    let crew: [CrewResult]
}

struct CastResult: Codable {
    let cast_id: Int
    let character: String
    let credit_id: String
    let gender: Int?
    let id: Int
    let name: String
    let order: Int
    let profile_path: String?
}

struct CrewResult: Codable {
    let credit_id: String
    let department: String
    let gender: Int?
    let id: Int
    let job: String
    let name: String
    let profile_path: String?
}
