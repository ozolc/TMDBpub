//
//  ProductionCompany.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 11/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct ProductionCompany: Codable {
    let name: String
    let id: Int
    let logo_path: String?
    let origin_country: String
}
