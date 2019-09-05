//
//  TodaySingleCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class TodaySingleCell: BaseImageCell {
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            originalTitleLabel.text = movie.original_title
            
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: movie.poster_path ?? "", posterSize: Constants.PosterSize.w342.rawValue)) {
                
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        posterImageView.layer.borderWidth = 0.1
        posterImageView.layer.borderColor = UIColor.darkGray.cgColor
//        posterImageView.constrainHeight(constant: 145)
//        posterImageView.constrainWidth(constant: 85)
        posterImageView.constrainHeight(constant: 140)
        
                posterImageView.contentMode = .scaleAspectFill
//                posterImageView.layer.cornerRadius = 16
                posterImageView.clipsToBounds = true
        
        let titleStackView = VerticalStackView(arrangedSubviews: [
            titleLabel,
//            originalTitleLabel
            ])
//        titleStackView.constrainHeight(constant: 66)
        titleStackView.alignment = .center
        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.layoutMargins = .init(top: 2, left: 4, bottom: 2, right: 4)
        
        let overallStackView = VerticalStackView(arrangedSubviews: [posterImageView,
//                                                                    titleLabel,
//                                                                    originalTitleLabel
                                                                    titleStackView
            ], spacing: 2)
        overallStackView.alignment = .center
        overallStackView.distribution = .fill
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
