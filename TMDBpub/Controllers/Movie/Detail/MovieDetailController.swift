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
    
    fileprivate var movieId: Int!
    fileprivate var movie: Movie!
    fileprivate var reviews: Review!
    
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
        
        tableView.tableFooterView = UIView()
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
        
        dispatchGroup.enter()
        let typeOfRequest = "movie/\(movieId ?? 0)"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  {[weak self] (movie: Movie) in
            
            self?.movie = movie
            dispatchGroup.leave()
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
        if let movie = self.movie {
            cell.movie = movie
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 390
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
    func similarsButtonPressed(sender: MovieDetailToolCell) {
        let typeOfRequest = "movie/\(movieId ?? 0)/similar"
        let controller = GenericMoviesControllers(typeOfRequest: typeOfRequest)
        controller.navigationItem.title = "Похожие фильмы"
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
