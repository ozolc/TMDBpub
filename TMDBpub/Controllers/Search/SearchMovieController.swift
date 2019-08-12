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
    fileprivate let typeOfRequest = Constants.searchMovies
    fileprivate let infoAboutMovie = "/movie/"
    fileprivate var totalPages = 0
    fileprivate var query = ""
    
    fileprivate var movies = [Movie]()
    fileprivate lazy var listCells = [
        ListCell(id: 1, title: "Upcoming", description: "Get a list of upcoming movies in theatres."),
        ListCell(id: 2, title: "Top Rated", description: "Get the top rated movies on TMDb.")
    ]
    
    fileprivate let cellId = "cellId"
    fileprivate let upcomingId = "upcomingId"
    fileprivate let footerId = "footerId"
    
    fileprivate var isUseMovies = false
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Grid").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleClearSearchResult))
    }
    
    fileprivate func listePressed() {
        print("Pressed")
    }
    
    @objc fileprivate func handleClearSearchResult() {
        movies.removeAll()
        isUseMovies = false
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        handleClearSearchResult()
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            handleClearSearchResult()
        } else {
            isUseMovies = true
            
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
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(SearchMovieCell.self, forCellReuseIdentifier: cellId)
        tableView.register(MovieUpcomingCell.self, forCellReuseIdentifier: upcomingId)
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
        if isUseMovies {
            let movie = movies[indexPath.row]
            
            let controller = MovieDetailController(movieId: movie.id)
            controller.navigationItem.title = movie.title
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let cell = listCells[indexPath.row]
            print(cell.description)
            
            var controller = UIViewController()
            switch cell.id {
            case 1:
                controller = PopularMoviesControllers(typeOfRequest: Constants.upcoming)
            case 2:
                controller = PopularMoviesControllers(typeOfRequest: Constants.topRatedMovies)
            default:
                break
            }
            
            controller.navigationItem.title = cell.title
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUseMovies {
            return movies.count
        } else {
            if section == 0 {
                return listCells.count
            }
        }
        return 5
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    // FIXME: - при results = nil перебирает пустые значения
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isUseMovies {
        case true:
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
            
        case false:
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: upcomingId, for: indexPath) as? MovieUpcomingCell else {
                    return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
                }
                let list = listCells[indexPath.row]
                cell.listCell = list
                
//                APIService.shared.fetchMoviesStat(typeOfRequest: Constants.upcoming) { [weak self] (result: ResultsMovie) in
//
//                    self?.totalPages = result.total_pages ?? 1
//                    self?.movies = result.results
//                    self?.isUseMovies = true
//
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//
//                }
                
                return cell
                
            default:
                return UITableViewCell(style: .default, reuseIdentifier: cellId)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch isUseMovies {
        case false:
            if section == 0 {
                return "Lists"
            } else if section == 1 {
                return "Section 1"
            }
        default:
            return "Searched"
        }
        return nil
    }
}
