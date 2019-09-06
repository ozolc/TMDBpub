//
//  PersonListController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonListController: BaseListController {
    
//    lazy var authManager = AuthenticationManager()
    
    var persons = [ResultSinglePerson]()
    var currentPage = AppState.shared.currentPage
    var typeOfRequest = Constants.popularPersons
    var totalPages = AppState.shared.totalPages
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppState.shared.resetPageDetails()
        
        setupCollectionView()
        fetchData()
        LoaderController.shared.showLoader()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(GenericPersonCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(GenericMovieFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    fileprivate func fetchData() {
        APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: self.currentPage, completionHandler: { [weak self] (result: ResultPerson) in
            
            self?.totalPages = result.total_pages ?? 1
            if let result = result.results {
                self?.persons = result
                print(result.count)
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                LoaderController.shared.removeLoader()
            }
            
        })
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GenericPersonCell
        
        let person = self.persons[indexPath.item]
        cell.person = person
        
        // initiate pagination
        if indexPath.item == self.persons.count - 1 && !isPaginating && self.currentPage < self.totalPages {
            print(indexPath.item)
            
            //            print("fetch more data from page", self.currentPage)
            
            self.currentPage += 1
            isPaginating = true
            
            APIService.shared.fetchMoviesStat(typeOfRequest: typeOfRequest, page: currentPage, completionHandler: { [weak self] (result: ResultPerson) in
                
                if result.results?.count == 0 {
                    self?.isDonePaginating = true
                }
                
                if let result = result.results {
                    self?.persons += result
                }
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                self?.isPaginating = false
            })
        }
        
        return cell
    }
    
    fileprivate let spacing: CGFloat = 16
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = persons[indexPath.item]
        guard let personId = person.id else { return }
        let controller = PersonController(personId: personId)
        controller.navigationItem.title = person.name ?? ""
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * spacing) / 2
        return CGSize(width: width, height: width * 1.65)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = (isDonePaginating || self.currentPage >= self.totalPages) ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
}

