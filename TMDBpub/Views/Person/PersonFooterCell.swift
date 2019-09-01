//
//  PersonFooterCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 01/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonFooterCell: UICollectionReusableView {
    
    var isMoreMovies = false {
        didSet {
            if isMoreMovies == true {
                showMoreButton.isHidden = false
            }
        }
    }
    
    let moviePersonLabel = UILabel(text: "Movies", font: .boldSystemFont(ofSize: 20))
    let showMoreButton = UIButton(title: "Show all", titleColor: .black, font: .boldSystemFont(ofSize: 12), backgroundColor: .white, target: self, action: #selector(handleShowMoreImages))
    let horizontalController = PersonMoviesController()
    
    //    weak var delegate: PersonImageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showMoreButton.isHidden = true
        
        addSubview(moviePersonLabel)
        addSubview(showMoreButton)
        addSubview(horizontalController.view)
        
        showMoreButton.addTarget(self, action: #selector(handleShowMoreImages), for: .touchUpInside)
        
        moviePersonLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: showMoreButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 4))
        showMoreButton.anchor(top: moviePersonLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        horizontalController.view.anchor(top: moviePersonLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 20, bottom: 0, right: 20))
        
        addSeparator(at: [.bottom],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 0, left: 15, bottom: -4, right: 20))
    }
    
    @objc fileprivate func handleShowMoreImages() {
        //        delegate?.didTappedShowAllImages()
        print("Show more movies")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
