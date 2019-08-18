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
            
            print(movie.id)
            
            let releaseYearSubstring = movie.release_date.prefix(4)
            releaseDateLabel.text = releaseYearSubstring.toYear()
            
            if let runtime = movie.runtime {
                runtimeLabel.text = runtime.toTime()
            }
            
            countryLabel.text = movie.production_countries?.first?.iso_3166_1 ?? ""
            genreLabel.text = movie.genres?.first?.name
            
            if let backdropUrl = URL(string: Constants.fetchBackdropUrl(withBackdropPath: movie.backdrop_path ?? "", backdropSize: Constants.BackdropSize.w780.rawValue)) {
                backdropImageView.sd_setImage(with: backdropUrl, placeholderImage: UIImage(named: Constants.moviePosterPlaceholderImageName), options: .continueInBackground) { (_, _, _, _) in
                    self.backdropImageView.isHidden = false
                }
            }
            
            if let miniPosterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: movie.poster_path ?? "", posterSize: Constants.PosterSize.w185.rawValue)) {
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
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        label.constrainWidth(constant: 34)
        return label
    }()
    
    let productionCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()
    
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        label.constrainWidth(constant: 40)
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()
    
    let tmdbImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "tmdb").withRenderingMode(.alwaysOriginal))
        iv.constrainHeight(constant: 35)
        iv.constrainWidth(constant: 35)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var backdropImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: Constants.moviePosterPlaceholderImageName))
        iv.contentMode = .scaleAspectFill
        iv.isHidden = true
        return iv
    }()
    
    let miniPosterImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.layer.borderWidth = 0.1
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        setupGradientLayer()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(backgrondView)
        backgrondView.fillSuperview()
        
        backgrondView.addSubview(backdropImageView)
        backdropImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        backdropImageView.constrainHeight(constant: 300)
        
        let posterView = UIView()
        posterView.layer.shadowOpacity = 0.1
        posterView.layer.shadowRadius = 10
        posterView.layer.shadowOffset = .init(width: 0, height: 10)
        posterView.layer.shouldRasterize = true
        
        posterView.addSubview(miniPosterImageView)
        miniPosterImageView.fillSuperview()
        
        backgrondView.addSubview(posterView)
        posterView.anchor(top: nil, leading: leadingAnchor, bottom: backdropImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: -24, right: 0), size: .init(width: 104, height: 154))
        
        voteAverageLabel.constrainWidth(constant: 45)
        
        let titleStackView = UIStackView(arrangedSubviews: [
            VerticalStackView(arrangedSubviews: [titleLabel, originalTitleLabel], spacing: 2),
            tmdbImageView,
            voteAverageLabel
            ])
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        backgrondView.addSubview(titleStackView)
        titleStackView.anchor(top: miniPosterImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 12, bottom: 2, right: 12))
        
        let sideTopStackView = UIStackView(arrangedSubviews: [
            releaseDateLabel,
            runtimeLabel,
            genreLabel,
            countryLabel,
            UIView()
            ])
        sideTopStackView.spacing = 4
        sideTopStackView.distribution = .fill
        
        backgrondView.addSubview(sideTopStackView)
        sideTopStackView.anchor(top: backdropImageView.bottomAnchor, leading: posterView.trailingAnchor, bottom: nil, trailing: titleStackView.trailingAnchor, padding: .init(top: 2, left: 16, bottom: 0, right: 0))
    }
    
    fileprivate func setupGradientLayer() {
//         how we can draw a gradient with Swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.5, 0.75]
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
