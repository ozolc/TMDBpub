//
//  MovieDetailCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            
            if let backdropUrl = URL(string: Constants.fetchBackdropUrl(withBackdropPath: movie.backdrop_path ?? "", backdropSize: Constants.BackdropSize.w780.rawValue)) {
                backdropImageView.sd_setImage(with: backdropUrl)
            }
            
            if let miniPosterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: movie.poster_path ?? "", posterSize: Constants.PosterSize.w92.rawValue)) {
                miniPosterImageView.sd_setImage(with: miniPosterUrl)
            }
            
        }
    }
    
    let backgrondView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.numberOfLines = 2
//        label.constrainHeight(constant: 24)
        return label
    }()
    
    lazy var backdropImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: Constants.moviePosterPlaceholderImageName))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let miniPosterImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: Constants.moviePosterPlaceholderImageName))
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.1
        iv.layer.borderColor = UIColor.darkGray.cgColor
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(backgrondView)
        backgrondView.fillSuperview()
        
        backgrondView.addSubview(backdropImageView)
        backdropImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        let posterView = UIView()
        posterView.addSubview(miniPosterImageView)
        miniPosterImageView.fillSuperview()
        
        backgrondView.addSubview(posterView)
        posterView.anchor(top: nil, leading: leadingAnchor, bottom: backdropImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: -24, right: 0), size: .init(width: 104, height: 154))
        
        posterView.layer.shadowOpacity = 0.2
        posterView.layer.shadowRadius = 10
        posterView.layer.shadowOffset = .init(width: 10, height: 10)
        posterView.layer.shouldRasterize = true
        
        posterView.addSubview(titleLabel)
        titleLabel.anchor(top: miniPosterImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 14, left: 12, bottom: 0, right: 12))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
}
