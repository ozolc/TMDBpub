//
//  TodayNowPlayingMoviesDetailController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 06/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

protocol TodayNowPlayingMoviesDetailDelegate: class {
    func didTappedNowPlayingMovie(movie: Movie)
}

import UIKit

class TodayNowPlayingMoviesDetailController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    fileprivate let spacing: CGFloat = 8
    
    weak var delegate: TodayNowPlayingMoviesDetailDelegate?
    
    var movies: [Movie]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TodaySingleNowPlayingMovieCell.self, forCellWithReuseIdentifier: cellId)
        //        collectionView.backgroundColor = .purple
        //        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showMovieDetail(indexPath)
    }
    
    fileprivate func showMovieDetail(_ indexPath: IndexPath) {
        
        guard let movies = movies else { return }
        let movie = movies[indexPath.item]
        
        delegate?.didTappedNowPlayingMovie(movie: movie)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(9, movies?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = (collectionView.bounds.size.height - spacing)
        let cellWidth = (collectionView.bounds.size.width - 2 * spacing) / 3
        
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        
        //        let width = (view.frame.width - 2 * spacing) / 3
        //        return CGSize(width: width, height: width * 1.6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodaySingleNowPlayingMovieCell
        
        if let movies = movies {
            let movie = movies[indexPath.item]
            cell.movie = movie
        }
        
        return cell
    }
    
    
}

