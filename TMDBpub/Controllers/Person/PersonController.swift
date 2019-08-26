//
//  PersonController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 26/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonController: BaseListController {
    
    let cellId = "id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PersonGroupCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PersonGroupCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
}
