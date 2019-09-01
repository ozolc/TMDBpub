//
//  Dictionary+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
    
}
