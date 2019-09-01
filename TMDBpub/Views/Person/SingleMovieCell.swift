//
//  SingleMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 01/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class SingleMovieCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 70)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.constrainWidth(constant: 140)
        imageView.constrainHeight(constant: 140)
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        imageView.layer.borderWidth = 0.2
        
//        backgroundColor = .yellow
//        imageView.fillSuperview()
    }
    
    func configureCell(movie: Movie) {
        guard let filePath = movie.poster_path else { return }
        let imageUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: filePath, posterSize: Constants.PosterSize.w500.rawValue))
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: imageUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
