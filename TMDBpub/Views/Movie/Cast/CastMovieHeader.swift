//
//  CastMovieHeader.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 15/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class CastMovieHeader: UICollectionReusableView {
    
    lazy var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.frame =  CGRect(x: 16, y: 2, width: frame.width-16, height: 20) //width equals to parent view with 10 left and right margin
        title.font = title.font.withSize(18)
        
        backgroundColor = #colorLiteral(red: 0.9368147254, green: 0.9384798408, blue: 0.955131948, alpha: 1)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
