//
//  ReviewsMovieController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ReviewsMovieController: UITableViewController {
    
    var reviews = [ReviewResult]()
    var totalPages = AppState.shared.totalPages
    
    fileprivate var movieId: Int!
    fileprivate let reviewId = "reviewId"
    
    // dependency injection constructor
    init(movieId: Int) {
        self.movieId = movieId
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppState.shared.resetPageDetails()
        
        LoaderController.shared.showLoader()
        fetchReview(byId: movieId)
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.register(ReviewMovieCell.self, forCellReuseIdentifier: reviewId)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        
        tableView.tableFooterView = UIView()
        
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    fileprivate func fetchReview(byId id: Int) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        let typeOfRequest = "movie/\(movieId ?? 0)/reviews"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  { [weak self] (reviews: Review) in
            
            self?.totalPages = reviews.total_pages ?? 1
            self?.reviews = reviews.results
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: .main) {
                LoaderController.shared.removeLoader()
                self?.tableView.reloadData()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reviewId, for: indexPath) as? ReviewMovieCell else {
            return UITableViewCell(style: .default, reuseIdentifier: reviewId)
        }
        
        let review = reviews[indexPath.row]
        cell.review = review
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ОТЗЫВЫ"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let title = UILabel()
        title.frame =  CGRect(x: 16, y: 5, width: headerFrame.size.width-16, height: 20) //width equals to parent view with 10 left and right margin
        title.font = title.font.withSize(18)
        title.text = self.tableView(tableView, titleForHeaderInSection: section) //This will take title of section from 'titleForHeaderInSection' method or you can write directly
        
        let headerView: UIView = UIView()
//        frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        view.addSubview(headerView)
        headerView.backgroundColor = #colorLiteral(red: 0.9368147254, green: 0.9384798408, blue: 0.955131948, alpha: 1)
        headerView.addSubview(title)
        
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: headerFrame.size.width, height: title.frame.size.height + 8))
        
        return headerView
    }
    
}
