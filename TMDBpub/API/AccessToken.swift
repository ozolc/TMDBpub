//
//  AccessToken.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    
    let token: String
    let accountId: String
    
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case accountId = "account_id"
    }
    
}
