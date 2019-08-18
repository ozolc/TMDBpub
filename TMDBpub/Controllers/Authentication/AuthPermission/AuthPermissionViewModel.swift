//
//  AuthPermissionViewModel.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

final class AuthPermissionViewModel {
    
    let requestToken: String
    
    var authPermissionURL: URL? {
        return URL(string: "https://www.themoviedb.org/auth/access?request_token=\(requestToken)")
    }
    
    init(requestToken: String) {
        self.requestToken = requestToken
    }
    
}
