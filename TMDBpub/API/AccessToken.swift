//
//  AccessToken.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 20/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    
    let sessionId: String
    let accountId: String
    
    private enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case accountId = "account_id"
    }
    
}

