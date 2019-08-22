//
//  AccountNavBar.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 22/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AccountTopCell: UITableViewCell {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "reviewProfile"))
    let usernameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16, weight: .bold))
    let nameLabel = UILabel(text: "NAME", font: .systemFont(ofSize: 12, weight: .regular))
    
    var user: User! {
        didSet {
            usernameLabel.text = user.username
            
            let attributedUsernameLabelText = NSMutableAttributedString(string: user.name, attributes: [.foregroundColor: UIColor.darkGray])
            nameLabel.attributedText = attributedUsernameLabelText
            
            let hashUrl = user.avatar.gravatar.hash
            userProfileImageView.sd_setImage(with: URL(string: Constants.gravatarImageURL + hashUrl))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        setupUI()
    }
    
    fileprivate  func setupUI() {
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        backgroundColor = .white
        
        let middleStack = VerticalStackView(arrangedSubviews: [
            userProfileImageView,
            usernameLabel,
            nameLabel
            ], spacing: 2)
        middleStack.alignment = .center
        hstack(middleStack).alignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
