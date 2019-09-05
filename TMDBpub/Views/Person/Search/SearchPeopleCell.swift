//
//  SearchPeopleCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 03/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class SearchPeopleCell: UITableViewCell {
    
    var person: ResultSinglePerson! {
        didSet {
            nameLabel.text = person.name
            
            if let popularity = person.popularity {
                let popularityString = String(popularity.truncate(to: 1))
                popularityLabel.text = popularityString
            }
            
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: person.profile_path ?? "", posterSize: Constants.PersonImageSize.w300_and_h450_bestv2.rawValue)) {

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
            
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
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
    
    let popularityLabel: UILabel = {
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
        let infoStackView = VerticalStackView (arrangedSubviews: [nameLabel,
//                                                                  genreLabel,
//                                                                  releaseDateLabel
            ], spacing: 4)
        infoStackView.distribution = .fillEqually
        
        let tmdbStackView = UIStackView(arrangedSubviews: [tmdbImageView, popularityLabel])
        tmdbStackView.constrainWidth(constant: 70)
        tmdbStackView.spacing = 2
        tmdbStackView.distribution = .fillEqually
        
        let overallStackView = UIStackView(arrangedSubviews: [posterImageView,
                                                              infoStackView,
                                                              tmdbStackView
            ])
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
