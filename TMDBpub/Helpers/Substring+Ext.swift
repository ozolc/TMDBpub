//
//  Substring+Ext.swift
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
