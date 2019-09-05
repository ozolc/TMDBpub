//
//  PopularPersonsDetailController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

protocol PopularPersonsDetailDelegate: class {
    func didTappedPerson(person: ResultSinglePerson)
}

import UIKit

class PopularPersonsDetailController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    fileprivate let spacing: CGFloat = 16
    
    weak var delegate: PopularPersonsDetailDelegate?
    
    var popularPersons: [ResultSinglePerson]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TodaySinglePopularPeopleCell.self, forCellWithReuseIdentifier: cellId)
        //        collectionView.backgroundColor = .purple
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showMovieDetail(indexPath)
    }
    
    fileprivate func showMovieDetail(_ indexPath: IndexPath) {
        
        guard let persons = popularPersons else { return }
        let person = persons[indexPath.item]
        
        delegate?.didTappedPerson(person: person)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(9, popularPersons?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 4 * spacing) / 3
        return CGSize(width: width, height: width * 1.60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodaySinglePopularPeopleCell
        
        if let popularPersons = popularPersons {
            let person = popularPersons[indexPath.item]
            cell.person = person
        }
        
        return cell
    }
    
    
}
