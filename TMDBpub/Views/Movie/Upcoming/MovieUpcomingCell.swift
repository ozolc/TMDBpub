//
//  MovieUpcomingCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 12/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieUpcomingCell: UITableViewCell {
    
    var yourobj : ((String) -> Void)? = nil
    
    var listCell: ListCell! {
        didSet {
            textLabel?.text = listCell.title
            detailTextLabel?.text = listCell.description
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .yellow
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
