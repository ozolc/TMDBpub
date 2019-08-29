//
//  AppFullscreenHeaderCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 29/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AppFullscreenHeaderCell: UICollectionViewCell {
    
    let todayCell = PhotoCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(todayCell)
        todayCell.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

