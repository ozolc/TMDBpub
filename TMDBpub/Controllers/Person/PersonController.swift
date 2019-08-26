//
//  PersonController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 26/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonController: BaseListController {
    
//    lazy var person = Person(birthday: "", knownForDepartment: "", deathday: "", id: 0, name: "", alsoKnownAs: [""], gender: [0], biography: "", popularity: 0, placeOfBirth: "", profile_path: "", adult: false, imdb_id: "", homepage: "")
    fileprivate var person: Person!
    fileprivate var typeOfRequest = ""
    
    
    let cellId = "id"
    
    // dependency injection constructor
    
    init(_ coder: NSCoder? = nil, personId: Int) {
        super.init()
        self.typeOfRequest = Constants.Person + "/" + String(personId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest) { (person: Person) in
            
            print(person)
            cell.configureCell(person: person)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
}
