//
//  MovieDetailMiddleCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 11/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailMiddleCell: UITableViewCell {
    
    var movie: Movie! {
        didSet {
//            releaseDateLabel.text = movie.release_date
        }
    }

    let topLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.init(white: 0.75, alpha: 1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black
        label.text = "movie.release_date"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .yellow
        
//        print(movie.release_date)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
//        addSubview(topLineView)
//        topLineView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 2, left: 5, bottom: 0, right: 5))
        
        addSubview(releaseDateLabel)
        releaseDateLabel.centerInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
