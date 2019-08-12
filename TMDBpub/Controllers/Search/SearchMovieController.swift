//
//  SearchMovieController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 11/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SearchMovieController: UITableViewController, UISearchBarDelegate {
    
    fileprivate var currentPage = 1
    fileprivate let typeOfRequest = "search/movie"
    fileprivate let infoAboutMovie = "/movie/"
    
    fileprivate var totalPages = 0
    fileprivate var movies = [Movie]()
    fileprivate var query = ""
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: searchText, page: self.currentPage) { [weak self] (result: ResultsMovie) in
                
                self?.totalPages = result.total_pages ?? 1
                self?.movies = result.results
                self?.query = searchText
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(SearchMovieCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SearchMovieFooterCell.self, forHeaderFooterViewReuseIdentifier: footerId)
        
        tableView.separatorStyle = .none
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let controller = MovieDetailController(movieId: movie.id)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    // FIXME: - при results = nil перебирает пустые значения
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchMovieCell else {
                return UITableViewCell(style: .default, reuseIdentifier: cellId)
            }
            
            let movie = movies[indexPath.row]
            cell.movie = movie
            
            if let genres = movie.genre_ids {
                if genres.count > 0 {
                    let filteredGenres = genresArray.filter({ (e) -> Bool in
                        return e.id == genres[0]
                    })
                    cell.genreNameArray = filteredGenres.map({$0.name})
                }
            }
        
            // initiate pagination
            if indexPath.item == self.movies.count - 1 && !isPaginating {

                self.currentPage += 1
                print("fetch more data from page", self.currentPage)

                isPaginating = true

//                let movieIdString = String(movie.id)
//                let infoAboutMediaUrlString = infoAboutMovie + movieIdString
                
                APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: self.query, page: self.currentPage) { [weak self] (result: ResultsMovie) in

//                    if result.results.count != 0 {
//                        self?.isDonePaginating = true
//                    }


                    self?.movies += result.results
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.isPaginating = false
                }
            }
            
            return cell
        }()
        
        return cell
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId)
//        return footer
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let height: CGFloat = (isDonePaginating || self.currentPage > self.totalPages) ? 0 : 100
//        return height
//    }
}
