//
//  TodaySinglePopularPeopleCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class TodaySinglePopularPeopleCell: BaseImageCell {
    
    var person: ResultSinglePerson! {
        didSet {
            titleLabel.text = person.name
            
            if let posterUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: person.profile_path ?? "", posterSize: Constants.PersonImageSize.w300_and_h450_bestv2.rawValue)) {
                
                posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                posterImageView.sd_setImage(with: posterUrl, placeholderImage: nil, options: [.highPriority]) {
                    (image, error, _, _) in
                    if (error != nil) {
                        self.posterImageView.image = UIImage(named: "reviewProfile")
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
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        posterImageView.layer.borderWidth = 0.1
        posterImageView.layer.borderColor = UIColor.darkGray.cgColor
//        posterImageView.constrainHeight(constant: 140)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        let titleStackView = VerticalStackView(arrangedSubviews: [titleLabel])
        titleStackView.alignment = .center
        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.layoutMargins = .init(top: 2, left: 4, bottom: 2, right: 4)
        
        let overallStackView = VerticalStackView(arrangedSubviews: [posterImageView,
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
