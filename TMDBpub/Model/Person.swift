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
    let gender: Gender
    let biography: String
    let popularity: Double
    let placeOfBirth: String?
    let profile_path: String?
    let adult: Bool
    let imdb_id: String
    let homepage: String?
    
//    private enum CodingKeys: String, CodingKey {
//        case knownForDepartment = "known_for_department"
//        case alsoKnownAs = "also_known_as"
//        case placeOfBirth = "place_of_birth"
//        case profilePath = "profile_path"
//        case imdbId = "imdb_id"
//    }

}

enum Gender: Codable {
    
    case notSpecified, male, female
    case other(name: Int)
    
    private enum RawValue: Int, Codable {
        
        case notSpecified = 0
        case male = 1
        case female = 2
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(Int.self)
        
        if let value = RawValue(rawValue: decodedString) {
            switch value {
            case .notSpecified:
                self = .notSpecified
            case .male:
                self = .male
            case .female:
                self = .female
            }
        } else {
            self = .other(name: decodedString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .notSpecified:
            try container.encode(RawValue.notSpecified)
        case .male:
            try container.encode(RawValue.male)
        case .female:
            try container.encode(RawValue.female)
        case .other(let name):
            try container.encode(name)
        }
    }
}
