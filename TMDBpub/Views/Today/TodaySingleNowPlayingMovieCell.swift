//
//  TodaySingleNowPlayingMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 06/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class TodaySingleNowPlayingMovieCell: BaseImageCell {
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            
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
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.constrainHeight(constant: 20)
        return label
    }()
    
    lazy var posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        backgroundColor = .yellow
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        self.backgroundView?.layer.cornerRadius = 0
        
        posterImageView.layer.borderWidth = 0.1
        posterImageView.layer.borderColor = UIColor.darkGray.cgColor
        //        posterImageView.constrainHeight(constant: 140)
        //        posterImageView.constrainWidth(constant: 154)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        let imageStackView = UIStackView(arrangedSubviews: [posterImageView])
        
        let titleStackView = VerticalStackView(arrangedSubviews: [titleLabel])
        titleStackView.alignment = .center
        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.layoutMargins = .init(top: 2, left: 4, bottom: 2, right: 4)
        
        let overallStackView = VerticalStackView(arrangedSubviews: [imageStackView,
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
