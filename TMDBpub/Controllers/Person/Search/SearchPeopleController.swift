//
//  SearchPeopleController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 03/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SearchPeopleController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
        
        let tableView = UITableView()
        
        fileprivate var currentPage = AppState.shared.currentPage
        fileprivate let typeOfRequest = Constants.searchPerson
        fileprivate let infoAboutMovie = "/people/"
        fileprivate var totalPages = AppState.shared.totalPages
        fileprivate var query = ""
        
        fileprivate var persons = [ResultSinglePerson]()
        //    fileprivate var persons = [Person]()
        
        fileprivate lazy var listCells = [
            ListCell(id: 1, title: "Предстоящие фильмы", description: "Получите список предстоящих фильмов в кинотеатрах."),
            ListCell(id: 2, title: "Топ рейтинг фильмов", description: "Получите список оценок фильмов на TMDb.")
        ]
        
        fileprivate let cellId = "cellId"
        fileprivate let upcomingId = "upcomingId"
        fileprivate let genreId = "genreId"
        fileprivate let footerId = "footerId"
        
        fileprivate var isSearchMode = false
        
        let searchController = UISearchController(searchResultsController: nil)
        var timer: Timer?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            view.backgroundColor = .white
            
            AppState.shared.resetPageDetails()
            navigationController?.navigationItem.hidesBackButton = true
            
            setupTableView()
            setupSearchBar()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Grid").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleClearSearchResult))
            
            view.addSubview(tableView)
            tableView.fillSuperview()
            
        }
    
    
        @objc fileprivate func handleClearSearchResult() {
            persons.removeAll()
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
                    
                    APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: searchText, page: self.currentPage, completionHandler: { [weak self] (result: ResultPerson) in
                        self?.totalPages = result.total_pages ?? 1
                        
                        if let result = result.results {
                            self?.persons = result
                        }
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
            tableView.register(SearchPeopleCell.self, forCellReuseIdentifier: cellId)
//            tableView.register(MovieUpcomingCell.self, forCellReuseIdentifier: upcomingId)
//            tableView.register(GenresMovieCell.self, forCellReuseIdentifier: genreId)
//            tableView.register(SearchMovieFooterCell.self, forHeaderFooterViewReuseIdentifier: footerId)
        }
        
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
//        parent?.navigationItem.searchController = self.searchController
        parent?.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if isSearchMode {
                let person = persons[indexPath.row]
                guard let personId = person.id else { return }
                
                let controller = PersonController(personId: personId)
                controller.navigationItem.title = person.name
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
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return isSearchMode ? 1 : 0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isSearchMode {
                return persons.count
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchPeopleCell else {
                    return UITableViewCell(style: .default, reuseIdentifier: cellId)
                }
                
                let person = persons[indexPath.row]
                cell.person = person
                print(person)
                
                // initiate pagination
                if indexPath.item == self.persons.count - 1 && !isPaginating {
                    
                    self.currentPage += 1
                    print("fetch more data from page", self.currentPage)
                    
                    isPaginating = true
                    
                    APIService.shared.fetchMoviesStat(typeOfRequest: self.typeOfRequest, query: self.query, page: self.currentPage, completionHandler: { [weak self] (result: ResultPerson) in
                        
                        //                    if result.results.count != 0 {
                        //                        self?.isDonePaginating = true
                        //                    }
                        
                        if let results = result.results {
                            self?.persons += results
                        }
                        
                        if let persons = self?.persons {
                            self?.persons = persons.sorted(by: { ($0.popularity ?? 0) > ($1.popularity ?? 0) })
                        }
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                        self?.isPaginating = false
                    })
                }
                
                return cell
                
            case false:
                print("false")
                return UITableViewCell(style: .default, reuseIdentifier: cellId)

//                switch indexPath.section {
//                case 0:
//                    guard let cell = tableView.dequeueReusableCell(withIdentifier: upcomingId, for: indexPath) as? MovieUpcomingCell else {
//                        return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
//                    }
//                    let list = listCells[indexPath.row]
//                    cell.listCell = list
                
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
                    
//                    return cell
//
//                case 1:
//                    guard let cell = tableView.dequeueReusableCell(withIdentifier: genreId, for: indexPath) as? GenresMovieCell else {
//                        return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
//                    }
                
//                    let genre = genresArray[indexPath.row]
//                    cell.genreCell = genre
//
//                    return cell
                
//                default:
//                    return UITableViewCell(style: .default, reuseIdentifier: cellId)
//                }
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

    
//}
