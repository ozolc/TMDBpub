//
//  UITableView+Ext.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 24/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit


extension UITableView {
    
    ///Get visible cell height
    var visibleCellsHeight: CGFloat {
        return visibleCells.reduce(0) { $0 + $1.frame.height }
    }
}
