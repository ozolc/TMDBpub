//
//  MovieDetailController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {
    
    var tableView = UITableView()
    
    var isFavourited = false
    
    fileprivate var movieId: Int!
    fileprivate var movie: Movie!
    fileprivate var reviews: Review!
    fileprivate var movieState: MovieState! {
        didSet {
            isFavourited = movieState.favorite
            updateRighBarButton(isFavourite: isFavourited)
        }
    }
    
    var sideBV = SideButtonsView()
    var buttonsArr = [RHButtonView]()
    fileprivate let triggerButtonMargin = CGFloat(85)
    
    // dependency injection constructor
    init(coder: NSCoder? = nil, movieId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.movieId = movieId
    }
    
    let cellId = "cellId"
    let toolId = "toolId"
    let middleId = "middleId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
        
        LoaderController.shared.showLoader()
        fetchData()
        setupSideButtons()
        
//        sideBV.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.fillSuperview()
//        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        view.addSubview(sideBV)
//        sideBV.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sideBV.sideButtonsView?.reloadButtons()
    }
    
    fileprivate func addSideButtons() {
        
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
            $0.image = UIImage(named: "trigger_img")
            $0.hasShadow = true
        }
        
        let sideButtonsView = RHSideButtons(parentView: view, triggerButton: triggerButton)
        sideButtonsView.delegate = self
        sideButtonsView.dataSource = self
        
        for index in 1...3 {
            buttonsArr.append(generateButton(withImgName: "icon_\(index)"))
        }
        
        guard let height = tabBarController?.tabBar.frame.origin.y else { return }
        sideButtonsView.setTriggerButtonPosition(CGPoint(x: view.bounds.width - triggerButtonMargin, y: height - triggerButtonMargin))
        
        
//        castView().set(sideButtonsView: sideButtonsView)
//        castView().sideButtonsView?.reloadButtons()
        
        sideBV.set(sideButtonsView: sideButtonsView)
        sideBV.sideButtonsView?.reloadButtons()
    }
    
    fileprivate func setupSideButtons() {
        addSideButtons()
    }
    
    fileprivate func generateButton(withImgName imgName: String) -> RHButtonView {
        
        return RHButtonView {
            $0.image = UIImage(named: imgName)
            $0.hasShadow = true
        }
    }
    
//    override func loadView() {
//        view = SideButtonsView()
//    }
    
//    func castView() -> SideButtonsView {
//        return view as! SideButtonsView
//    }
    
    fileprivate func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
            self?.dispatchGroup.leave()
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
        
        let rightButton = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    
    @objc fileprivate func handleFavorite() {
        APIService.shared.postToFavorites(mediaType: .Movie, mediaId: movieId, isFavorite: !self.isFavourited) { (response, error) in
            if let error = error {
                print(error)
            }
        }
        
        print(self.isFavourited)
        self.isFavourited = !self.isFavourited
        self.updateRighBarButton(isFavourite: isFavourited);
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    let dispatchGroup = DispatchGroup()
    
    fileprivate func fetchData() {
        
        dispatchGroup.enter()
        
        let typeOfRequest = "movie/\(movieId ?? 0)"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  {[weak self] (movie: Movie) in

            self?.movie = movie
            self?.fetchFavoriteState()
            
        })
        
        dispatchGroup.notify(queue: .main) {
            LoaderController.shared.removeLoader()
            self.tableView.reloadData()
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

extension MovieDetailController: RHSideButtonsDataSource {
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return buttonsArr.count
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return buttonsArr[index]
    }
}

extension MovieDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

extension MovieDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 440
            //            390
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension MovieDetailController: RHSideButtonsDelegate {
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        print("🍭 button index tapped: \(index)")
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        print("🍭 Trigger button")
    }
}
