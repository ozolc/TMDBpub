//
//  MovieUpcomingCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 12/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieUpcomingCell: UITableViewCell {
    
    var listCell: ListCell! {
        didSet {
            titleLabel.text = listCell.title
            descriptionTitleLabel.text = listCell.description
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupLayout() {
        let stackView = VerticalStackView(arrangedSubviews: [titleLabel, descriptionTitleLabel])
        stackView.alignment = .leading
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 4, left: 16, bottom: 4, right: 16))
    }
    
}
