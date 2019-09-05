//
//  TodayPopularPersonsCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 05/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

protocol TodayPersonsCellDelegate: class {
    func didTappedShowAllPopularPersons()
}

import UIKit

class TodayPopularPersonsCell: UICollectionViewCell {
    
    weak var delegate: TodayPersonsCellDelegate!
    
    let popularPersonsLabel = UILabel(text: "Popular Persons", font: .boldSystemFont(ofSize: 20))
    let showMorePopularPersonsButton = UIButton(title: "Show all", titleColor: .black, font: .boldSystemFont(ofSize: 12), backgroundColor: .white, target: self, action: #selector(handleShowMorePopularPersons))
    
    let popularPersonsHorizontalController = PopularPersonsDetailController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(popularPersonsLabel)
        addSubview(showMorePopularPersonsButton)
        addSubview(popularPersonsHorizontalController.view)
        
        showMorePopularPersonsButton.addTarget(self, action: #selector(handleShowMorePopularPersons), for: .touchUpInside)
        
        popularPersonsLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: showMorePopularPersonsButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 4))
        showMorePopularPersonsButton.anchor(top: popularPersonsLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        popularPersonsHorizontalController.view.anchor(top: popularPersonsLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 20, bottom: 0, right: 20))
    }
    
    @objc fileprivate func handleShowMorePopularPersons() {
        delegate?.didTappedShowAllPopularPersons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
