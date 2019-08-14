//
//  CastMovieController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class CastMovieController: BaseListController {
    
    var casts = [CastResult]()
    var crewPeople = [CrewResult]()
    var typeOfRequest = ""
    
    fileprivate let cellId = "cellId"
    
    init(typeOfRequest: String) {
        super.init()
        self.typeOfRequest = typeOfRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(CastMovieCell.self, forCellWithReuseIdentifier: cellId)
        LoaderController.shared.showLoader()
        fetchData()
    }
    
    fileprivate func fetchData() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
//        let typeOfRequest = "movie/\(movieId ?? 0)"
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, completionHandler:  {[weak self] (cast: Cast) in
            
            self?.casts = cast.cast
            self?.crewPeople = cast.crew
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            LoaderController.shared.removeLoader()
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return casts.count
        } else {
            return crewPeople.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CastMovieCell
            let cast = self.casts[indexPath.item]
            cell.cast = cast
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CrewMovieCell
            let crewPeople = self.crewPeople[indexPath.item]
            cell.crewPeole = crewPeople
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 4 * 16) / 3
        return CGSize(width: width, height: width + 126)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
