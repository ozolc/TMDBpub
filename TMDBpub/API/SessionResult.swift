//
//  SessionResult.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct SessionResult: Decodable {
    
    let success: Bool
    let sessionId: String?
    
    private enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
    
}
