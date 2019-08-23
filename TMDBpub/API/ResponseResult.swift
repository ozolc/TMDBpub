//
//  ResponseResult.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 23/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct ResponseResult: Codable {
    let statusCode: Int
    let statusMessage: String
    
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

