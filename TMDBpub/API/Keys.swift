//
//  Keys.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 20/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

/// Decodable Struct to retrieve the read api key from a property list.
struct Keys: Decodable {

    let apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "ApiKey"
    }
    
}
