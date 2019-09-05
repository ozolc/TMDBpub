//
//  TodayController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class TodayController: BaseListController {
    
    let popularMoviesCellId = "popularMoviesCellId"
    let popularPersonsCellId = "popularPersonsCellId"
    
    var movies = [Movie]()
    var persons = [ResultSinglePerson]()
    var currentPage = AppState.shared.currentPage
    var typeOfRequestPopularMovies = Constants.popularMovies
    var typeOfRequestPopularPersons = Constants.popularPersons
    var totalPages = AppState.shared.totalPages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TodayPopularMoviesCell.self, forCellWithReuseIdentifier: popularMoviesCellId)
        collectionView.register(TodayPopularPersonsCell.self, forCellWithReuseIdentifier: popularPersonsCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularMoviesCellId, for: indexPath) as! TodayPopularMoviesCell
            
            cell.delegate = self
            cell.popularMoviesHorizontalController.delegate = self
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestPopularMovies, page: self.currentPage, completionHandler: { [weak self] (result: ResultsMovie) in
                
                self?.totalPages = result.total_pages ?? 1
                self?.movies = result.results
                
                cell.popularMoviesHorizontalController.popularMovies = self?.movies
            })
            
        return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularPersonsCellId, for: indexPath) as! TodayPopularPersonsCell
            
            cell.delegate = self
            cell.popularPersonsHorizontalController.delegate = self
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestPopularPersons, page: self.currentPage, completionHandler: { [weak self] (result: ResultPerson) in
                
                self?.totalPages = result.total_pages ?? 1
                if let results = result.results {
                    self?.persons = results
                }
                
                cell.popularPersonsHorizontalController.popularPersons = self?.persons
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
        return .init(top: 8, left: 0, bottom: 0, right: 0)
    }
}

extension TodayController: TodayMoviesCellDelegate {
    func didTappedShowAllPopularMovies() {
        let controller = GenericMoviesControllers(typeOfRequest: Constants.popularMovies)
        controller.navigationItem.title = "Popular movies"
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TodayController: TodayPopularMoviesDetailDelegate {
    func didTappedMovie(movie: Movie) {
        let controller = MovieDetailController(movieId: movie.id)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TodayController: TodayPersonsCellDelegate {
    func didTappedShowAllPopularPersons() {
        let controller = PersonListController()
        controller.navigationItem.title = "Popular People"
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TodayController: PopularPersonsDetailDelegate {
    func didTappedPerson(person: ResultSinglePerson) {
        guard let personId = person.id else { return }
        let controller = PersonController(personId: personId)
        controller.navigationItem.title = person.name
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

