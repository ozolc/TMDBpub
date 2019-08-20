//
//  PopularMoviesControllers.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 09/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit


class GenericMoviesControllers: BaseListController {
    
    lazy var authManager = AuthenticationManager()
    
    var movies = [Movie]()
    var currentPage = AppState.shared.currentPage
    var typeOfRequest = ""
    var totalPages = AppState.shared.totalPages
    var with_genres: String? = nil
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    
    init(_ coder: NSCoder? = nil, typeOfRequest: String) {
        super.init()
        self.typeOfRequest = typeOfRequest
    }
    
    init(_ coder: NSCoder?, typeOfRequest: String, with_genres: String) {
        self.typeOfRequest = typeOfRequest
        self.with_genres = with_genres
        
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppState.shared.resetPageDetails()
        
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.setRightBarButton(logoutButton, animated: true)
    
        setupCollectionView()
        fetchData()
        LoaderController.shared.showLoader()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(GenericMovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(GenericMovieFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    @objc private func handleLogout() {
        authManager.deleteCurrentUser()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    fileprivate func fetchData() {
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: self.currentPage, with_genres: with_genres ,completionHandler: { [weak self] (result: ResultsMovie) in
            
            self?.totalPages = result.total_pages ?? 1
            self?.movies = result.results
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                LoaderController.shared.removeLoader()
            }
            
        })
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GenericMovieCell
        
        let movie = self.movies[indexPath.item]
        cell.movie = movie
        
//        // initiate pagination
        if indexPath.item == self.movies.count - 1 && !isPaginating {
            
            self.currentPage += 1
            print("fetch more data from page", self.currentPage)

            isPaginating = true
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: currentPage, with_genres: with_genres, completionHandler: { [weak self] (result: ResultsMovie) in

                if result.results.count == 0 {
                    self?.isDonePaginating = true
                }

                self?.movies += result.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                self?.isPaginating = false
            })
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let controller = MovieDetailController(movieId: movie.id)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 126)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = (isDonePaginating || self.currentPage > self.totalPages) ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
}
