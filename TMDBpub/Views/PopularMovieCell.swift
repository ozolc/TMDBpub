//
//  PopularMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 09/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PopularMovieCell: UICollectionViewCell {
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            originalTitleLabel.text = movie.original_title
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(white: 0.9, alpha: 1)
        return label
    }()
    
    lazy var posterImageView = UIImageView(cornerRadius: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        posterImageView.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
        
        let titleStackView = VerticalStackView(arrangedSubviews: [titleLabel, originalTitleLabel], spacing: 2)
        titleStackView.constrainHeight(constant: 36)
        
        let overallStackView = VerticalStackView(arrangedSubviews: [posterImageView, titleStackView], spacing: 2)
        overallStackView.backgroundColor = .blue
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
