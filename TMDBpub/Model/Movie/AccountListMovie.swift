//
//  AccountListMovie.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 22/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

class AccountListMovie {
    let name: String
    let path: Constants.AccountLists
    
    init(name: String, path: Constants.AccountLists) {
        self.name = name
        self.path = path
    }
}
