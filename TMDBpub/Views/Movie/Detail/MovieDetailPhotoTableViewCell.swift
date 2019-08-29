//
//  MovieDetailPhotoTableViewCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 29/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol MovieDetailPhotoTableViewCellDelegate: class {
    func didTappedFromDelegate(movieImagesFromDelegate: MovieImage)
}

class MovieDetailPhotoTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: MovieDetailPhotoTableViewCellDelegate!
    
    var collectionView: UICollectionView!
    let imageCellId = "imageCellId"
    var typeOfRequestImages = ""
    
    var movieImages: MovieImage!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PersonImageCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView.backgroundColor = UIColor.white
        
        self.collectionView.isScrollEnabled = false
        self.collectionView.isPagingEnabled = false
        
        self.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 250
        return .init(width: self.bounds.width, height: height)
        //        return .init(width: self.bounds.width, height: self.bounds.height)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PersonImageCell
        cell.delegate = self
        
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestImages) { [weak self] (movieImage: MovieImage) in
            guard let self = self else { return }
            self.movieImages = movieImage
            
            cell.horizontalController.personImages = self.movieImages.backdrops
            
            if cell.horizontalController.personImages?.count ?? 0 > 4 {
                cell.isMoreImages = true
            }
        }
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension MovieDetailPhotoTableViewCell: PersonImageCellDelegate {
    func didTappedShowAllImages() {
        delegate.didTappedFromDelegate(movieImagesFromDelegate: movieImages)
        
    }
    
}
