//
//  PersonController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 26/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import Foundation

class PersonController: BaseListController {
    
    fileprivate var person: Person!
    fileprivate var typeOfRequest = ""
    fileprivate var typeOfRequestImages = ""
    fileprivate var personName = ""
    
    let detailCellId = "detailCellId"
    let imageCellId = "imageCellId"
    let footerId = "footerId"
    
    var personImages: [ImageStruct]?
    var movies: [Movie]?
    var isLoadedDataForFooter = false {
        didSet {
        collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // dependency injection constructor
    init(_ coder: NSCoder? = nil, personId: Int) {
        super.init()
        self.typeOfRequest = Constants.Person + "/" + String(personId)
        self.typeOfRequestImages = Constants.Person + "/" + String(personId) + "/" + Constants.Images
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PersonDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(PersonImageCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView.register(PersonFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        collectionView.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! PersonDetailCell
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest) { (person: Person) in
                cell.configureCell(person: person)
                self.personName = person.name
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PersonImageCell
            cell.delegate = self
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestImages) { [weak self] (images: PersonImage) in
                guard let self = self else { return }
                self.personImages = images.profiles
                cell.horizontalController.personImages = self.personImages
                
                if self.personImages?.count ?? 0 > 4 {
                    cell.isMoreImages = true
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height250: CGFloat = personImages?.isEmpty ?? false ? 0 : 250
        let height400: CGFloat = 400
        
        if indexPath.item == 0 {
            return .init(width: view.frame.width, height: height400)
        } else {
            return .init(width: view.frame.width, height: height250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! PersonFooterCell
        
        footer.delegate = self
        footer.horizontalController.delegate = self
        
        let typeOfRequestMovie = self.typeOfRequest + Constants.movie_credits
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestMovie) { [weak self] (movies: MovieByPerson) in
            guard let self = self else { return }
            self.movies = movies.cast
            
            footer.horizontalController.movies = self.movies
            self.isLoadedDataForFooter = true
            
            if self.personImages?.count ?? 0 > 5 {
                footer.isMoreMovies = true
            }
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = movies?.isEmpty ?? false ? 0 : 190
        return .init(width: view.frame.width, height: height)
    }
    
}

extension PersonController: PersonImageCellDelegate {
    func didTappedShowAllImages() {
        if let personImages = personImages {
            let controller = PersonImagesListController(personImages: personImages)
            controller.navigationItem.title = personName
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension PersonController: PersonFooterCellDelegate {
    func didTappedShowAllMovies() {
        if let movies = movies {
        let controllerMovie = PersonMoviesListController(movies: movies)
        controllerMovie.navigationItem.title = personName
        navigationController?.pushViewController(controllerMovie, animated: true)
        }
    }
}

extension PersonController: PersonMoviesControllerDelegate {
    func didTappedMovie(movie: Movie) {
        print("in realization delegate action", movie.id)
        let controller = MovieDetailController(movieId: movie.id)
        controller.navigationItem.title = movie.title
        navigationController?.pushViewController(controller, animated: true)
    }
}
