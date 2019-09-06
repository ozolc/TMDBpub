//
//  TodayNowPlayingMoviesCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 06/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

protocol TodayNowPlayingMoviesCellDelegate: class {
    func didTappedShowAllNowPlayingMovies()
}

import UIKit

class TodayNowPlayingMoviesCell: UICollectionViewCell {
    
    weak var delegate: TodayNowPlayingMoviesCellDelegate!
    
    let nowPlayingLabel = UILabel(text: "Now Playing", font: .boldSystemFont(ofSize: 20))
    let showNowPlayingButton = UIButton(title: "Show all", titleColor: .black, font: .boldSystemFont(ofSize: 12), backgroundColor: .white, target: self, action: #selector(handleShowMoreNowPlayingMovies))
    
    let nowPlayingMoviesHorizontalController = TodayNowPlayingMoviesDetailController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nowPlayingLabel)
        addSubview(showNowPlayingButton)
        addSubview(nowPlayingMoviesHorizontalController.view)
        
        showNowPlayingButton.addTarget(self, action: #selector(handleShowMoreNowPlayingMovies), for: .touchUpInside)
        
        nowPlayingLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: showNowPlayingButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 4))
        showNowPlayingButton.anchor(top: nowPlayingLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        nowPlayingMoviesHorizontalController.view.anchor(top: nowPlayingLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 20, bottom: 0, right: 20))
    }
    
    @objc fileprivate func handleShowMoreNowPlayingMovies() {
        delegate?.didTappedShowAllNowPlayingMovies()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

