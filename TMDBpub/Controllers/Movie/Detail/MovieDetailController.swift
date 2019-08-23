//
//  MovieDetailController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailController: UITableViewController {
    
    weak var movieDetailToolCellView: MovieDetailToolCell?
    
    var isFavourited = false
    
    fileprivate var movieId: Int!
    fileprivate var movie: Movie!
    fileprivate var reviews: Review!
    fileprivate var movieState: MovieState! {
        didSet {
            let isFavourited = movieState.favorite
            updateRighBarButton(isFavourite: isFavourited)
        }
    }
    
    // dependency injection constructor
    init(movieId: Int) {
        self.movieId = movieId
        super.init(style: .plain)
    }
    
    let cellId = "cellId"
    let toolId = "toolId"
    let middleId = "middleId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setupVisualBlurEffectView()
        setupTableView()
        
        LoaderController.shared.showLoader()
        fetchData()
    }
    
    fileprivate func setupTableView() {
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: cellId)
        tableView.register(MovieDetailToolCell.self, forCellReuseIdentifier: toolId)
        tableView.register(MovieDetailMiddleCell.self, forCellReuseIdentifier: middleId)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func fetchFavoriteState() {
        let typeOfRequestStates = "movie/\(movieId ?? 0)/account_states"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestStates, sessionId: Constants.sessionId, completionHandler: { [weak self] (state: MovieState) in
            
            self?.movieState = state
            print(state)
        })
    }
    
    func updateRighBarButton(isFavourite: Bool) {
        let favoriteButton = UIButton()
        favoriteButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        if isFavourite {
            favoriteButton.setImage(UIImage(named: "FavoriteOn"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "FavoriteOff"), for: .normal)
        }
        self.isFavourited = !self.isFavourited
        
        let rightButton = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    
    @objc fileprivate func handleFavorite() {
        APIService.shared.postToFavorites(mediaType: .Movie, mediaId: movieId, isFavorite: self.isFavourited) { [weak self] (response, error) in
            if let error = error {
                print(error)
            } else {
//                guard let isFavourited = self?.isFavourited else { return }
//                self?.updateRighBarButton(isFavourite: isFavourited)
                print(self?.isFavourited)
            }
        }
        
        self.updateRighBarButton(isFavourite: isFavourited);
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func fetchData() {
        
        let dispatchGroup = DispatchGroup()
        
        let typeOfRequest = "movie/\(movieId ?? 0)"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  {[weak self] (movie: Movie) in
            dispatchGroup.enter()
            
            self?.movie = movie
            self?.fetchFavoriteState()
        })
        
        dispatchGroup.notify(queue: .main) {
            LoaderController.shared.removeLoader()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MovieDetailCell
            if let movie = self.movie {
                cell.movie = movie
            }
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: toolId) as! MovieDetailToolCell
            cell.delegate = self
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: middleId) as! MovieDetailMiddleCell
        
        cell.delegate = self
        
        if let movie = self.movie {
            cell.movie = movie
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 440
            //            390
        } else {
            return UITableView.automaticDimension
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension MovieDetailController: MovieDetailToolCellDelegate {
    
    func castButtonPressed(sender: MovieDetailToolCell) {
        let typeOfRequest = "movie/\(movieId ?? 0)/credits"
        let controller = CastMovieController(typeOfRequest: typeOfRequest)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func reviewButtonPressed(sender: MovieDetailToolCell) {
        let controller = ReviewsMovieController(movieId: movieId)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func trailersButtonPressed(sender: MovieDetailToolCell) {
        let movieIdString = String(movieId)
        let controller = TrailerMovieController(movieId: movieIdString)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func similarsButtonPressed(sender: MovieDetailToolCell) {
        let typeOfRequest = "movie/\(movieId ?? 0)/similar"
        let controller = GenericMoviesControllers(typeOfRequest: typeOfRequest)
        controller.navigationItem.title = "Похожие фильмы"
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MovieDetailController: MovieDetailMiddleCellDelegate {
    func favoriteButtonPressed(sender: MovieDetailMiddleCell) {
        print("button pressed")
        APIService.shared.postToFavorites(mediaType: .Movie, mediaId: movieId, isFavorite: !sender.isFavorite) { (response, error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    sender.isFavorite = !sender.isFavorite
                    sender.favoriteButton.setTitleColor((sender.isFavorite) ? UIColor.red :  UIColor.black, for: .normal) 
                    print(sender.isFavorite)
                }
                
            }
        }
    }
    
    
}
