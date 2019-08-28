//
//  String+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 11/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

extension Substring {
    func toYear() -> String {
        return String(self.prefix(4))
    }
}

extension String {
    func replaceHyphenToDot() -> String {
        let aString = self
        let newString = aString.replacingOccurrences(of: "-", with: ".")
        return newString
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
