//
//  MovieDetailMiddleCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 11/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol MovieDetailMiddleCellDelegate: class {
    func favoriteButtonPressed(sender: MovieDetailMiddleCell)
}

class MovieDetailMiddleCell: UITableViewCell {
    
    weak var delegate: MovieDetailMiddleCellDelegate?
    
    var isFavorite = true
    
    var movie: Movie! {
        didSet {
            overviewTextView.text = movie.overview ?? "Без описания"
        }
    }
    
    let overviewTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.backgroundColor = .white
        tv.font = .systemFont(ofSize: 14, weight: .regular)
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let favoriteButton = UIButton(title: "Favorite", titleColor: .red)
    
    @objc fileprivate func handleFavorite() {
        delegate?.favoriteButtonPressed(sender: self)
        print(isFavorite)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSeparator(at: [.top],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 5, left: 15, bottom: 0, right: 15))
//        addSubview(overviewTextView)
//        overviewTextView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
        
        favoriteButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        addSubview(favoriteButton)
        favoriteButton.centerInSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
