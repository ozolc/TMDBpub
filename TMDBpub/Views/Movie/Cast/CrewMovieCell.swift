//
//  CrewMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class CrewMovieCell: UICollectionViewCell {
    
    var crewPeople: CrewResult! {
        didSet {
            
            nameLabel.text = crewPeople.name
            departmentLabel.text = crewPeople.department
            
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: crewPeople.profile_path ?? "", posterSize: Constants.PosterSize.w154.rawValue)) {
                crewImageView.sd_setImage(with: posterUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
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
    
    let departmentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var crewImageView = UIImageView(cornerRadius: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        crewImageView.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
        crewImageView.contentMode = .scaleAspectFill
        crewImageView.layer.cornerRadius = 8
        crewImageView.clipsToBounds = true
        crewImageView.layer.borderWidth = 0.1
        crewImageView.layer.borderColor = UIColor.darkGray.cgColor
        
        let titleStackView = VerticalStackView(arrangedSubviews: [nameLabel, departmentLabel, UIView()], spacing: 2)
        titleStackView.constrainHeight(constant: 56)
        titleStackView.alignment = .center
        
        let overallStackView = VerticalStackView(arrangedSubviews: [crewImageView, titleStackView], spacing: 2)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
