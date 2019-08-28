//
//  PersonImagesListController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 28/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonImagesListController: BaseListController {
    
    let singleImageCellId = "singleImageCellId"
    
    var personImages: [ImageStruct]?
//    {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    init(personImages: [ImageStruct]) {
        self.personImages = personImages
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SingleImageCell.self, forCellWithReuseIdentifier: singleImageCellId)
        
        collectionView.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singleImageCellId, for: indexPath) as! SingleImageCell
        
        if let personImage = personImages?[indexPath.item] {
            cell.configureCell(profile: personImage)
        }
        return cell
            
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4 * spacing) / 3
        return CGSize(width: width, height: width + 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


