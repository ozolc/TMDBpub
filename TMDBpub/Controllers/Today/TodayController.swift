//
//  TodayController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class TodayController: BaseListController {
    
    let popularCellId = "popularCellId"
    
    var movies = [Movie]()
    var currentPage = AppState.shared.currentPage
    var typeOfRequest = Constants.popularMovies
    var totalPages = AppState.shared.totalPages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: popularCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularCellId, for: indexPath) as! TodayCell
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: self.currentPage, completionHandler: { [weak self] (result: ResultsMovie) in
                
                self?.totalPages = result.total_pages ?? 1
                self?.movies = result.results
                
                cell.popularMoviesHorizontalController.popularMovies = self?.movies
            })
            
        return cell
            
        default:
            return UICollectionViewCell.init(frame: .zero)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 0, bottom: 8, right: 0)
    }
}
