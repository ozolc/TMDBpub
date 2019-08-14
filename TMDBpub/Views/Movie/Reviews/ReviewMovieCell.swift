//
//  ReviewMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ReviewMovieCell: UITableViewCell {
    
    var review: ReviewResult! {
        didSet {
            reviewTextView.text = review.content
            authorLabel.text = review.author
        }
    }
    
    let authorImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "reviewProfile"))
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: 35)
        return iv
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let reviewTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 18, weight: .regular)
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSeparator(at: [.top],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 5, left: 15, bottom: 0, right: 15))
        
        let stackView = UIStackView(arrangedSubviews: [authorLabel, authorImageView])
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 15))
        
        addSubview(reviewTextView)
        reviewTextView.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: stackView.trailingAnchor, padding: .init(top: 4, left: 12, bottom: 4, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
