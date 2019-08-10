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
    var currentPage = 1
    let typeOfRequest = "movie/popular"
    var totalPages = 0
    
    let cellId = "cellId"
    fileprivate let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PopularMovieFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        fetchData()
    }
    
    fileprivate func fetchData() {
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: self.currentPage) { (result: ResultsMovie) in
            
            self.totalPages = result.total_pages ?? 1
            self.movies = result.results
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PopularMovieCell
        
        let movie = self.movies[indexPath.item]
        cell.movie = movie
        
//        // initiate pagination
        if indexPath.item == self.movies.count - 1 && !isPaginating && self.currentPage < self.totalPages {
            
            self.currentPage += 1
            print("fetch more data from page", self.currentPage)

            isPaginating = true
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: currentPage) { (result: ResultsMovie) in

                if result.results.count == 0 {
                    self.isDonePaginating = true
                    print(self.isDonePaginating)
                }

//                sleep(2)

                self.movies += result.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 156)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
}
