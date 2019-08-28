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
    
    let detailCellId = "detailCellId"
    let imageCellId = "imageCellId"
    
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
        
        collectionView.backgroundColor = .white
//        collectionView.contentInset = .init(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! PersonDetailCell
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest) { (person: Person) in
                cell.configureCell(person: person)
            }
            return cell
//            indexPath.item == 1
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PersonImageCell
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequestImages) { (images: PersonImage) in
                print(images)
                cell.horizontalController.personImages = images.profiles
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 350
        
        if indexPath.item == 0 {
            return .init(width: view.frame.width, height: 400)
        } else {
            return .init(width: view.frame.width, height: height)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var height: CGFloat = 400
//
//        if indexPath.item == 0 {
//            let dummyCell = PersonDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
//
////            dummyCell.app = app
//            dummyCell.layoutIfNeeded()
//
//            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
//            height = estimatedSize.height
//        } else if indexPath.item == 1 {
//            height = 500
//        } else {
//            height = 400
//        }
//
//        return .init(width: view.frame.width, height: height)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 0, bottom: 8, right: 0)
    }
    
}
