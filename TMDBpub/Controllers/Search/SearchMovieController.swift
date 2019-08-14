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
        ListCell(id: 1, title: "Предстоящие фильмы", description: "Получите список предстоящих фильмов в кинотеатрах."),
        ListCell(id: 2, title: "Топ рейтинг фильмов", description: "Получите список оценок фильмов на TMDb.")
    ]
    
    fileprivate let cellId = "cellId"
    fileprivate let upcomingId = "upcomingId"
    fileprivate let genreId = "genreId"
    fileprivate let footerId = "footerId"
    
    fileprivate var isSearchMode = false
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Grid").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleClearSearchResult))

        loadingGenresFromNet()

    }

    func loadingGenresFromNet() {
        let infoAboutGenre = Constants.infoAboutGenre
        APIService.shared.fetchMoviesStat(typeOfRequest: infoAboutGenre, language: Constants.language, completionHandler: { [weak self] (genre: Genre) in
            genresArray += genre.genres
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    
    @objc fileprivate func handleClearSearchResult() {
        movies.removeAll()
        isSearchMode = false
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
            isSearchMode = true
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                
                APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: searchText, page: self.currentPage, completionHandler: { [weak self] (result: ResultsMovie) in
                    self?.totalPages = result.total_pages ?? 1
                    self?.movies = result.results
                    self?.query = searchText
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                })
            })
        }
    }
          
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(SearchMovieCell.self, forCellReuseIdentifier: cellId)
        tableView.register(MovieUpcomingCell.self, forCellReuseIdentifier: upcomingId)
        tableView.register(GenresMovieCell.self, forCellReuseIdentifier: genreId)
        tableView.register(SearchMovieFooterCell.self, forHeaderFooterViewReuseIdentifier: footerId)
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
        if isSearchMode {
            let movie = movies[indexPath.row]
            
            let controller = MovieDetailController(movieId: movie.id)
            controller.navigationItem.title = movie.title
            navigationController?.pushViewController(controller, animated: true)
        }
            else
        {
            var controller = UICollectionViewController()
            if indexPath.section == 0 {
                let list = listCells[indexPath.row]
                
                switch list.id {
                case 1:
                    controller = GenericMoviesControllers(typeOfRequest: Constants.upcoming)
                case 2:
                    controller = GenericMoviesControllers(typeOfRequest: Constants.topRatedMovies)
                default:
                    print("break")
                }
                controller.navigationItem.title = list.title
                navigationController?.pushViewController(controller, animated: true)
            
            } else if indexPath.section == 1 {
                let genre = genresArray[indexPath.row]
                let with_genresString = String(genre.id)
                controller = GenericMoviesControllers(nil, typeOfRequest: Constants.discoverMovie, with_genres: with_genresString)
                controller.navigationItem.title = genre.name.firstCapitalized
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchMode ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return movies.count
        } else {
            if section == 0 {
                return listCells.count
            }
            else if section == 1 {
                return genresArray.count
            }
        }
        return 0
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    // FIXME: - при results = nil перебирает пустые значения
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isSearchMode {
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
                
                APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: self.query, page: self.currentPage, completionHandler: { [weak self] (result: ResultsMovie) in
                    
                    //                    if result.results.count != 0 {
                    //                        self?.isDonePaginating = true
                    //                    }
                    
                    
                    self?.movies += result.results
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.isPaginating = false
                })
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
                
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: genreId, for: indexPath) as? GenresMovieCell else {
                    return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
                }
                
                let genre = genresArray[indexPath.row]
                cell.genreCell = genre
                
                return cell
                
            default:
                return UITableViewCell(style: .default, reuseIdentifier: cellId)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch isSearchMode {
        case false:
            if section == 0 {
                return "РЕЙТИНГИ ФИЛЬМОВ"
            } else if section == 1 {
                return "ЖАНРЫ"
            }
        case true:
            return "РЕЗУЛЬТАТ ПОИСКА:"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearchMode {
            return 160
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let title = UILabel()
        title.frame =  CGRect(x: 16, y: 5, width: headerFrame.size.width-16, height: 20) //width equals to parent view with 10 left and right margin
        title.font = title.font.withSize(18)
        title.text = self.tableView(tableView, titleForHeaderInSection: section) //This will take title of section from 'titleForHeaderInSection' method or you can write directly
        
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = #colorLiteral(red: 0.9368147254, green: 0.9384798408, blue: 0.955131948, alpha: 1)
        headerView.addSubview(title)

        return headerView
    }
    
}
