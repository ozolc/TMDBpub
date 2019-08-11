//
//  MovieDetailCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            originalTitleLabel.text = movie.original_title
            voteAverageLabel.text = String(movie.vote_average)
            
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
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var backdropImageView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: Constants.moviePosterPlaceholderImageName))
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let miniPosterImageView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: Constants.moviePosterPlaceholderImageName))
        let iv = UIImageView(image: nil)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.1
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
//        setupGradientLayer()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(backgrondView)
        backgrondView.fillSuperview()
        
        backgrondView.addSubview(backdropImageView)
        backdropImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        backdropImageView.constrainHeight(constant: 300)
        
        setupGradientLayer()
        
        let posterView = UIView()
        posterView.layer.shadowOpacity = 0.1
        posterView.layer.shadowRadius = 10
        posterView.layer.shadowOffset = .init(width: 0, height: 10)
        posterView.layer.shouldRasterize = true
        
        posterView.addSubview(miniPosterImageView)
        miniPosterImageView.fillSuperview()
        
        backgrondView.addSubview(posterView)
        posterView.anchor(top: nil, leading: leadingAnchor, bottom: backdropImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: -24, right: 0), size: .init(width: 104, height: 154))
        posterView.addSubview(titleLabel)
        
        voteAverageLabel.constrainWidth(constant: 40)
        
        let sv = UIStackView(arrangedSubviews: [
            VerticalStackView(arrangedSubviews: [titleLabel, originalTitleLabel], spacing: 2),
            voteAverageLabel
            ])
        sv.spacing = 2
        sv.alignment = .center
        
        backgrondView.addSubview(sv)
        sv.anchor(top: miniPosterImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 12, bottom: 2, right: 12))
//        titleLabel.anchor(top: miniPosterImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 12, bottom: 0, right: 12))
//        backgrondView.addSubview(originalTitleLabel)
//        originalTitleLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        
    }
    
    fileprivate func setupGradientLayer() {
//         how we can draw a gradient with Swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.3, 0.85]
        // self.frame is actually zero frame
        backdropImageView.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
}
