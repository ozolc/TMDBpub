//
//  CastMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class CastMovieCell: UICollectionViewCell {
    
    var cast: CastResult! {
        didSet {
            
            nameLabel.text = cast.name
            characterLabel.text = cast.character
            
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: cast.profile_path ?? "", posterSize: Constants.PosterSize.w154.rawValue)) {
                
                castImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                castImageView.sd_setImage(with: posterUrl, placeholderImage: nil, options: [.highPriority]) {
                    (image, error, _, _) in
                    if (error != nil) {
                        self.castImageView.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
                    } else {
                        self.castImageView.image = image
                    }
                }
                
//                castImageView.sd_setImage(with: posterUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let characterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var castImageView = UIImageView(cornerRadius: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
//        castImageView.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
        castImageView.contentMode = .scaleAspectFill
        castImageView.layer.cornerRadius = 8
        castImageView.clipsToBounds = true
        castImageView.layer.borderWidth = 0.1
        castImageView.layer.borderColor = UIColor.darkGray.cgColor
        
        let titleStackView = VerticalStackView(arrangedSubviews: [nameLabel, characterLabel, UIView()], spacing: 2)
        titleStackView.constrainHeight(constant: 56)
        titleStackView.alignment = .center
        
        
        let overallStackView = VerticalStackView(arrangedSubviews: [castImageView, titleStackView], spacing: 2)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
