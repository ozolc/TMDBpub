//
//  MovieState.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 23/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

class MovieState: Codable {
    var id = 0
    var favorite = false
    var rated: Int?
    var watchlist = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case favorite
        case rated = "rated"
        case watchlist
    }
    
    class RatedValue: Codable {
        var value: Int
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let favorite = try container.decode(Bool.self, forKey: .favorite)
        let ratedBool = try? container.decode(Bool.self, forKey: .rated)
        let ratedValue = try? container.decode(RatedValue.self, forKey: .rated)
        self.rated = ratedValue?.value ?? (ratedBool != nil ? 0 : 0)
        let watchlist = try container.decode(Bool.self, forKey: .watchlist)
        
        self.id = id
        self.favorite = favorite
        self.watchlist = watchlist
    }
}
