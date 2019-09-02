//
//  PersonMoviesController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 01/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol PersonMoviesControllerDelegate: class {
    func didTappedMovie(movie: Movie)
}

class PersonMoviesController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: PersonMoviesControllerDelegate?
    
    let cellId = "cellId"
    
    var movies: [Movie]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SingleMovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func showMovieDetail(_ indexPath: IndexPath) {
        
        guard let movies = movies else { return }
        let movie = movies[indexPath.item]
        
        delegate?.didTappedMovie(movie: movie)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showMovieDetail(indexPath)
        print(indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(5, movies?.count ?? 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleMovieCell
        
        if let movie = movies?[indexPath.item] {
            cell.configureCell(movie: movie)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 140, height: 140)
    }
}


