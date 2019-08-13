//
//  GenresMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 13/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class GenresMovieCell: UITableViewCell {
    var genreCell: GenreStruct! {
        didSet {
            titleLabel.text = genreCell.name
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "RightArrow").withRenderingMode(.alwaysOriginal))
        iv.constrainWidth(constant: 20)
        iv.constrainHeight(constant: 20)
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupLayout() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 4, left: 16, bottom: 4, right: 0))
        
        addSubview(arrowImageView)
        arrowImageView.centerYInSuperview()
        arrowImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
    }
}
