//
//  TodayPopularMoviesCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

protocol TodayMoviesCellDelegate: class {
    func didTappedShowAllPopularMovies()
}

import UIKit

class TodayPopularMoviesCell: UICollectionViewCell {
    
    weak var delegate: TodayMoviesCellDelegate!
    
    let popularMoviesLabel = UILabel(text: "Popular Movies", font: .boldSystemFont(ofSize: 20))
    let showMorePopularMoviesButton = UIButton(title: "Show all", titleColor: .black, font: .boldSystemFont(ofSize: 12), backgroundColor: .white, target: self, action: #selector(handleShowMorePopularMovies))
    
    let popularMoviesHorizontalController = TodayPopularMoviesDetailController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(popularMoviesLabel)
        addSubview(showMorePopularMoviesButton)
        addSubview(popularMoviesHorizontalController.view)
        
        showMorePopularMoviesButton.addTarget(self, action: #selector(handleShowMorePopularMovies), for: .touchUpInside)
        
        popularMoviesLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: showMorePopularMoviesButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 4))
        showMorePopularMoviesButton.anchor(top: popularMoviesLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        popularMoviesHorizontalController.view.anchor(top: popularMoviesLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 20, bottom: 0, right: 20))
    }
    
    @objc fileprivate func handleShowMorePopularMovies() {
        delegate?.didTappedShowAllPopularMovies()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
