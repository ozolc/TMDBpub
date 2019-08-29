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
    
    var personImages: [ImageStruct]!
    
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
                
                if self.personImages.count > 4 {
                    cell.isMoreImages = true
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 250
        
        if indexPath.item == 0 {
            return .init(width: view.frame.width, height: 400)
        } else {
            return .init(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 0, bottom: 8, right: 0)
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
