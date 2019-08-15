//
//  TrailerMovieController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 15/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class TrailerMovieController: BaseListController {
    
    var videos = [VideoResult]()
    var movieId = ""
    let cellId = "cellId"
    
    init(movieId: String) {
        self.movieId = movieId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(TrailerMovieCell.self, forCellWithReuseIdentifier: cellId)
        
        LoaderController.shared.showLoader()
        fetchTrailers(byId: movieId)
    }
    
    fileprivate func fetchTrailers(byId id: String) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        let typeOfRequest = "movie/\(movieId)/videos"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  { [weak self] (videos: Video) in
            
            self?.videos = videos.results
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: .main) {
                LoaderController.shared.removeLoader()
                self?.collectionView.reloadData()
            }
        })
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrailerMovieCell
        
        let video = self.videos[indexPath.item]
        cell.video = video
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width - 2 * 16
        return CGSize(width: width, height: width)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
