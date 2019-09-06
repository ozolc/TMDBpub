//
//  SearchMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 12/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class SearchMovieCell: UITableViewCell {
    
    var genreNameArray: [String]! {
        didSet {
            let attributedGenreText = NSMutableAttributedString(string: "Жанр: ", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 12, weight: .bold)])
            attributedGenreText.append(NSAttributedString(string: genreNameArray.first ?? "", attributes: [.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 12, weight: .bold)]))
            genreLabel.attributedText = attributedGenreText
            }
        }
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            if let vote_average = movie.vote_average {
                voteAverageLabel.text = String(vote_average)
            }
            
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: movie.poster_path ?? "", posterSize: Constants.PosterSize.w154.rawValue)) {
                
                posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                posterImageView.sd_setImage(with: posterUrl, placeholderImage: nil, options: [.highPriority]) {
                    (image, error, _, _) in
                    if (error != nil) {
                        self.posterImageView.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
                    } else {
                        self.posterImageView.image = image
                    }
                }
            }
            
            if let release_date = movie.release_date {
                let attributedReleaseDateText = NSMutableAttributedString(string: "Дата: ", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 12, weight: .bold)])
                attributedReleaseDateText.append(NSAttributedString(string: release_date, attributes: [.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 12, weight: .bold)]))
                releaseDateLabel.attributedText = attributedReleaseDateText
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Жанр"
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()
    
    let posterImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 4
        iv.constrainWidth(constant: 96)
//        iv.constrainHeight(constant: 154)
        iv.clipsToBounds = true
        return iv
    }()
    
    let tmdbImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "tmdb").withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFit
//        iv.constrainWidth(constant: 15)
//        iv.constrainHeight(constant: 15)
        return iv
    }()
    
    let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        setupLayout()
        selectionStyle = .none
        
    }
    
    fileprivate func setupLayout() {
        let infoStackView = VerticalStackView (arrangedSubviews: [titleLabel,
                                                                  genreLabel, releaseDateLabel
            ], spacing: 4)
        infoStackView.distribution = .fillEqually
        
        let tmdbStackView = UIStackView(arrangedSubviews: [tmdbImageView, voteAverageLabel])
        tmdbStackView.constrainWidth(constant: 70)
        tmdbStackView.spacing = 2
        tmdbStackView.distribution = .fillEqually

        let overallStackView = UIStackView(arrangedSubviews: [posterImageView, infoStackView, tmdbStackView])
        overallStackView.distribution = .fill
        overallStackView.spacing = 8
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        addSeparator(at: [.bottom],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 5, left: 15, bottom: 0, right: 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    
}

