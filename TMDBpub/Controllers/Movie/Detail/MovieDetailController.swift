//
//  MovieDetailController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class RHButtonStruct {
    let text: [String]
    let buttonView: RHButtonView
    let typeOfParameter: Constants.ParameterKeysAccount
    var isChecked: Bool
    
    init(text: [String],
         buttonView: RHButtonView,
         typeOfParameter: Constants.ParameterKeysAccount,
         isChecked: Bool)
    {
        self.text = text
        self.buttonView = buttonView
        self.typeOfParameter = typeOfParameter
        self.isChecked = isChecked
    }
}

class MovieDetailController: UIViewController {
    
    var tableView = UITableView()
    var personImagesDetailController: PersonImagesDetailController!
    
    var isFavourited = false
    var isWatchlisted = false
    var isFirstState = true
    
    var movieImages: MovieImage!
    var typeOfRequestImages = ""
    
    fileprivate var movieId: Int!
    fileprivate var movie: Movie!
    fileprivate var reviews: Review!
    fileprivate var movieState: MovieState! {
        didSet {
            
            firstState(flag: isFirstState)
            
            for (index, value) in buttonsArr.enumerated() {
                updateAccountListButton(isChecked: value.isChecked, index: index)
            }
        }
    }
    
    fileprivate func firstState(flag: Bool) {
        if isFirstState {
            
            buttonsArr.forEach { (button) in
                switch button.typeOfParameter {
                case .Favorite:
                    button.isChecked = movieState.favorite
                case .Watchlist:
                    button.isChecked = movieState.watchlist
                }
            }
        }
        
        isFirstState = false
        self.sideBV.sideButtonsView?.reloadButtons()
    }
    
    var sideBV = SideButtonsView()
    var buttonsArr = [RHButtonStruct]()
    fileprivate let triggerButtonMargin = CGFloat(85)
    
    fileprivate var rating: Int!
    
    // dependency injection constructor
    init(coder: NSCoder? = nil, movieId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.movieId = movieId
        self.typeOfRequestImages = Constants.movie + "/" + String(movieId) + "/" + Constants.Images
    }
    
    let cellId = "cellId"
    let toolId = "toolId"
    let middleId = "middleId"
    let movieImageCellId = "movieImageCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchData()

        setupUI()
        addSideButtons()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.sideBV.sideButtonsView?.reloadButtons()
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        view.addSubview(sideBV)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func addSideButtons() {
        
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
            $0.image = UIImage(named: "trigger_img")
            $0.hasShadow = true
        }
        
        let sideButtonsView = RHSideButtons(parentView: view, triggerButton: triggerButton)
        sideButtonsView.delegate = self
        sideButtonsView.dataSource = self
        
        buttonsArr.append(RHButtonStruct(text: ["FavoriteOn", "FavoriteOff"],
                                         buttonView: generateButton(withImgName: "FavoriteOff"),
                                         typeOfParameter: Constants.ParameterKeysAccount.Favorite,
                                         isChecked: isFavourited))
        
        buttonsArr.append(RHButtonStruct(text: ["WatchlistOn", "WatchlistOff"],
                                         buttonView: generateButton(withImgName: "WatchlistOff"),
                                         typeOfParameter: Constants.ParameterKeysAccount.Watchlist,
                                         isChecked: isWatchlisted)
        
        )
        
        guard let height = tabBarController?.tabBar.frame.origin.y else { return }
        sideButtonsView.setTriggerButtonPosition(CGPoint(x: view.bounds.width - triggerButtonMargin, y: height - triggerButtonMargin))
        
        sideBV.set(sideButtonsView: sideButtonsView)
        sideBV.sideButtonsView?.reloadButtons()
    }
    
    fileprivate func handleFavorite(mediaType: Constants.MediaType, index: Int, typeOfParameter: Constants.ParameterKeysAccount, isChecked: Bool) {
        APIService.shared.postToFavorites(mediaType: mediaType, mediaId: movieId, isFavorite: !isChecked, typeOfParameter: typeOfParameter) { (response, error) in
            if let error = error {
                print(error)
            }
        }
        
        print(isChecked)
        buttonsArr[index].isChecked = !buttonsArr[index].isChecked
        self.updateAccountListButton(isChecked: buttonsArr[index].isChecked , index: index)
    }
    
    func updateAccountListButton(isChecked: Bool, index: Int) {
        if isChecked {
            guard let imgOn = UIImage(named: buttonsArr[index].text.first ?? "exit_icon") else { return }
            buttonsArr[index].buttonView.image = imgOn
        } else {
            guard let imgOff = UIImage(named: buttonsArr[index].text.last ?? "exit_icon") else { return }
            buttonsArr[index].buttonView.image = imgOff
        }
        sideBV.sideButtonsView?.reloadButtons()
    }
    
    fileprivate func generateButton(withImgName imgName: String) -> RHButtonView {
        
        return RHButtonView {
            $0.image = UIImage(named: imgName)
            $0.hasShadow = true
        }
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: cellId)
        tableView.register(MovieDetailToolCell.self, forCellReuseIdentifier: toolId)
        tableView.register(MovieDetailMiddleCell.self, forCellReuseIdentifier: middleId)
        tableView.register(MovieDetailPhotoTableViewCell.self, forCellReuseIdentifier: movieImageCellId)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.tableFooterView = UIView()
        
    }
    
    let dispatchGroup = DispatchGroup()
    
    fileprivate func fetchData() {
        self.dispatchGroup.enter()
        
        let typeOfRequest = "movie/\(movieId ?? 0)"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  {[weak self] (movie: Movie) in
            guard let self = self else { return }
            
            self.movie = movie
//            self.dispatchGroup.leave()
            self.fetchFavoriteState()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func fetchFavoriteState() {
        
        let typeOfRequestStates = "movie/\(movieId ?? 0)/account_states"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestStates, sessionId: Constants.sessionId, completionHandler: { [weak self] (state: MovieState) in
            guard let self = self else { return }
            self.dispatchGroup.enter()
            
            self.movieState = state
            self.rating = state.rated
            self.dispatchGroup.leave()
            self.dispatchGroup.leave()
            
        })
        
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
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
    }
    
}

extension MovieDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MovieDetailCell
            if let movie = self.movie {
                cell.movie = movie
                
                cell.ratingStackView.delegate = self
                cell.rating = rating
            }
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: toolId) as! MovieDetailToolCell
            cell.delegate = self
            
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: middleId) as! MovieDetailMiddleCell
            
            cell.delegate = self
            
            if let movie = self.movie {
                cell.movie = movie
            }
            return cell
        } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: movieImageCellId, for: indexPath) as! MovieDetailPhotoTableViewCell
            cell.typeOfRequestImages = self.typeOfRequestImages
            cell.delegate = self
            return cell
        }
    }
    
}

extension MovieDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 440
        } else if indexPath.row == 3 {
            return 250
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension MovieDetailController: RHSideButtonsDataSource {
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return buttonsArr.count
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return buttonsArr[index].buttonView
    }
}

extension MovieDetailController: RHSideButtonsDelegate {
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        print("🍭 button index tapped: \(index) and text: \(buttonsArr[index].text)")
        handleFavorite(mediaType: .Movie,
                       index: index,
                       typeOfParameter: buttonsArr[index].typeOfParameter,
                       isChecked: buttonsArr[index].isChecked)
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
//        print("🍭 Trigger button")
    }
}

extension MovieDetailController: MovieDetailPhotoTableViewCellDelegate {
    func didTappedFromDelegate(movieImagesFromDelegate: MovieImage) {
        let controller = PersonImagesListController(personImages: movieImagesFromDelegate.backdrops, isSingle: true)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MovieDetailController: RatingControlDelegate {
    func setRating(with rating: Int) {
        APIService.shared.postRateMovie(mediaId: movieId, rateValue: rating) { (response, error) in
            if let error = error {
                print(error)
            }
            self.rating = rating
            
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: [0, 0]) as? MovieDetailCell else { return }
                cell.ratingLabel.text = "(" + String(rating) + "/10)"
            }
        }
        
    }
    
    func deleteRating() {
        APIService.shared.deleteRateMovie(mediaId: movieId) { (response, error) in
            if let error = error {
                print(error)
            }
            
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: [0, 0]) as? MovieDetailCell else { return }
                cell.ratingLabel.text = "(0/10)"
            }
        }
    }
    
}
