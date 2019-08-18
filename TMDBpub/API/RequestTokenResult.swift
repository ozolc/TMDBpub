//
//  RequestTokenResult.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct RequestTokenResult: Codable {
    
    let success: Bool
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case success
        case token = "request_token"
    }
    
}
