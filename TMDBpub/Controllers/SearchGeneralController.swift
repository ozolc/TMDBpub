//
//  SearchGeneralController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SearchGeneralController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies", "Persons"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    @objc fileprivate func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rowsToDisplay.removeAll()
            rowsToDisplay = movies
//            rowsToDisplay.removeAll()
            typeOfRequest = typeOfRequestMovies
            AppState.shared.resetPageDetails()
        default:
            rowsToDisplay.removeAll()
            rowsToDisplay = persons
//            rowsToDisplay.removeAll()
            typeOfRequest = typeOfRequestPersons
            AppState.shared.resetPageDetails()
        }
        
        tableView.reloadData()
    }
    
    let tableView = UITableView()
    
    fileprivate var currentPage = AppState.shared.currentPage
    fileprivate let typeOfRequestMovies = Constants.searchMovies
    fileprivate let typeOfRequestPersons = Constants.searchPerson
    fileprivate let infoAboutMovie = "movie/"
    fileprivate let infoAboutPerson = "people/"
    fileprivate var typeOfRequest = ""
    fileprivate var totalPages = AppState.shared.totalPages
    fileprivate var query = ""
    
    fileprivate var movies = [Movie]()
    fileprivate var persons = [ResultSinglePerson]()
    
    // master array
    lazy var rowsToDisplay: [SearchProtocol] = movies
    
    fileprivate lazy var listCells = [
        ListCell(id: 1, title: "Предстоящие фильмы", description: "Получите список предстоящих фильмов в кинотеатрах."),
        ListCell(id: 2, title: "Топ рейтинг фильмов", description: "Получите список оценок фильмов на TMDb.")
    ]
    
    fileprivate let movieCellId = "movieCellId"
    fileprivate let personCellId = "personCellId"
    fileprivate let upcomingId = "upcomingId"
    fileprivate let genreId = "genreId"
    fileprivate let footerId = "footerId"
    
    fileprivate var isSearchMode = false
    
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeOfRequest = typeOfRequestMovies
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .white
        
        AppState.shared.resetPageDetails()
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = segmentedControl
        
        setupTableView()
        setupSearchBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Grid").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleClearSearchResult))
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        //        loadingGenresFromNet()
        
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
        rowsToDisplay.removeAll()
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
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
                guard let self = self else { return }
                
                switch self.segmentedControl.selectedSegmentIndex {
                case 0:
                    print("case 0")
                    APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: searchText, page: self.currentPage, completionHandler: {
                        [weak self] (result: ResultsMovie) in
                    self?.totalPages = result.total_pages ?? 1
                    self?.rowsToDisplay = result.results
                    self?.query = searchText
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                        
                    })
                    
                default:
                    print("default")
                    APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: searchText, page: self.currentPage, completionHandler: { [weak self] (result: ResultPerson) in
                        self?.totalPages = result.total_pages ?? 1
                        
                        if let result = result.results {
                            self?.rowsToDisplay = result
                        }
                        self?.query = searchText
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    })
                }
            })
        }
    }
    
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(SearchMovieCell.self, forCellReuseIdentifier: movieCellId)
        tableView.register(SearchPeopleCell.self, forCellReuseIdentifier: personCellId)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchMode {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let object = rowsToDisplay[indexPath.row] as! Movie
                let controller = MovieDetailController(movieId: object.id)
                controller.navigationItem.title = object.title
                navigationController?.pushViewController(controller, animated: true)
                
            default:
                let object = rowsToDisplay[indexPath.row] as! ResultSinglePerson
                guard let personId = object.id else { return }
                
                let controller = PersonController(personId: personId)
                controller.navigationItem.title = object.name
                navigationController?.pushViewController(controller, animated: true)
            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchMode ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return rowsToDisplay.count
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isSearchMode {
        case true:
            switch segmentedControl.selectedSegmentIndex {
            case 0:
            
                isPaginating = false
                isDonePaginating = false
                
            guard let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId, for: indexPath) as? SearchMovieCell else {
                return UITableViewCell(style: .default, reuseIdentifier: movieCellId)
            }
            
            let movie = rowsToDisplay[indexPath.row] as! Movie
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
            if indexPath.item == self.rowsToDisplay.count - 1 && !isPaginating {
                
                self.currentPage += 1
                print("fetch more data from page", self.currentPage)
                
                isPaginating = true
                
                APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequestMovies, query: self.query, page: self.currentPage, completionHandler: { [weak self] (result: ResultsMovie) in
                    
                    //                    if result.results.count != 0 {
                    //                        self?.isDonePaginating = true
                    //                    }
                    
                    
                    self?.rowsToDisplay += result.results
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.isPaginating = false
                })
            }
            
            return cell
                
            default:
                
                isPaginating = false
                isDonePaginating = false
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: personCellId, for: indexPath) as? SearchPeopleCell else {
                    return UITableViewCell(style: .default, reuseIdentifier: "cellId")
                }
                
                let person = rowsToDisplay[indexPath.row] as! ResultSinglePerson
                cell.person = person
                print(person)
                
                // initiate pagination
                if indexPath.item == self.rowsToDisplay.count - 1 && !isPaginating {
                    
                    self.currentPage += 1
                    print("fetch more data from page", self.currentPage)
                    
                    isPaginating = true
                    
                    APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: self.query, page: self.currentPage, completionHandler: { [weak self] (result: ResultPerson) in
                        
                        if let results = result.results {
                            self?.rowsToDisplay += results
                        }
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                        self?.isPaginating = false
                    })
                }
                
                return cell
            }
            
        case false:
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: upcomingId, for: indexPath) as? MovieUpcomingCell else {
                    return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
                }
                let list = listCells[indexPath.row]
                cell.listCell = list
                
                return cell
                
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: genreId, for: indexPath) as? GenresMovieCell else {
                    return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
                }
                
                let genre = genresArray[indexPath.row]
                cell.genreCell = genre
                
                return cell
                
            default:
                return UITableViewCell(style: .default, reuseIdentifier: movieCellId)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearchMode {
            return 160
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let title = UILabel()
        title.frame =  CGRect(x: 16, y: 2, width: headerFrame.size.width-16, height: 20) //width equals to parent view with 10 left and right margin
        title.font = title.font.withSize(18)
        title.text = self.tableView(tableView, titleForHeaderInSection: section) //This will take title of section from 'titleForHeaderInSection' method or you can write directly
        
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = #colorLiteral(red: 0.9368147254, green: 0.9384798408, blue: 0.955131948, alpha: 1)
        headerView.addSubview(title)
        
        return headerView
    }
    
}
