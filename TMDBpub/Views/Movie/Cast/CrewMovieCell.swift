//
//  CrewMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class CrewMovieCell: UICollectionViewCell {
    
    var crewPeole: CrewResult! {
        didSet {
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: crewPeole.profile_path ?? "", posterSize: Constants.PosterSize.w154.rawValue)) {
                crewImageView.sd_setImage(with: posterUrl, placeholderImage: #imageLiteral(resourceName: "reviewProfile"), options: .continueInBackground, completed: nil)
            }
        }
    }
    
    lazy var crewImageView = UIImageView(cornerRadius: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(crewImageView)
        crewImageView.fillSuperview(padding: .init(top: 15, left: 15, bottom: 15, right: 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
