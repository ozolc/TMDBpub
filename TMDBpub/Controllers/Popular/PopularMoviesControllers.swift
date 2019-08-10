//
//  PopularMoviesControllers.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 09/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PopularMoviesControllers: BaseListController {
    
    var movies = [Movie]()
    var page = 1
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .red
        
        collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchPopularMovies()
    }
    
    fileprivate func fetchPopularMovies() {
        APIService.shared.fetchMoviesStat(typeOfRequest: "movie/popular", page: self.page) { (result) in
            self.movies = result
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PopularMovieCell
        
        let movie = self.movies[indexPath.item]
        cell.movie = movie
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    
}
