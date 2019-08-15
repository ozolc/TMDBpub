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
    
    fileprivate let castId = "castId"
    fileprivate let crewId = "crewId"
    fileprivate let headerId = "headerId"
    
    init(typeOfRequest: String) {
        super.init()
        self.typeOfRequest = typeOfRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView.backgroundColor = .white
        
        collectionView.register(CastMovieCell.self, forCellWithReuseIdentifier: castId)
        collectionView.register(CrewMovieCell.self, forCellWithReuseIdentifier: crewId)
        collectionView?.register(CastMovieHeader.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        LoaderController.shared.showLoader()
        fetchData()
    }
    
    fileprivate func fetchData() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
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
         return (section == 0) ? casts.count : crewPeople.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castId, for: indexPath) as! CastMovieCell
            let cast = self.casts[indexPath.item]
            cell.cast = cast
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: crewId, for: indexPath) as! CrewMovieCell
            let crewPeople = self.crewPeople[indexPath.item]
            cell.crewPeople = crewPeople
            
            return cell
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSizeMake(UIScreen.mainScreen().bounds.width, 40)
        return .init(width: collectionView.frame.size.width, height: 24)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var caption = ""
        
        switch indexPath.section {
        case 0:
            caption = "CAST"
        case 1:
            caption = "CREW"
        default:
            break
        }
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! CastMovieHeader
            headerView.title.text = caption
            
            return headerView
        }
        return UICollectionReusableView()
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
