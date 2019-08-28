//
//  PersonImageCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 28/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol PersonImageCellDelegate: class {
    func didTappedShowAllImages()
}

class PersonImageCell: UICollectionViewCell {
    
    var isMoreImages = false {
        didSet {
            if isMoreImages == true {
                showMoreButton.isHidden = false
            }
        }
    }
    
    let imagePersonLabel = UILabel(text: "Изображения", font: .boldSystemFont(ofSize: 20))
    let showMoreButton = UIButton(title: "Смотреть все", titleColor: .black, font: .boldSystemFont(ofSize: 12), backgroundColor: .white, target: self, action: #selector(handleShowMoreImages))
    let horizontalController = PersonImagesDetailController()
    
    weak var delegate: PersonImageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showMoreButton.isHidden = true
        
        addSubview(imagePersonLabel)
        addSubview(showMoreButton)
        addSubview(horizontalController.view)
        
        showMoreButton.addTarget(self, action: #selector(handleShowMoreImages), for: .touchUpInside)
        
        imagePersonLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: showMoreButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 4))
        showMoreButton.anchor(top: imagePersonLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        horizontalController.view.anchor(top: imagePersonLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 20, bottom: 0, right: 20))
        
        addSeparator(at: [.bottom],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 0, left: 15, bottom: -4, right: 20))
    }
    
    @objc fileprivate func handleShowMoreImages() {
        print("Show more images")
        delegate?.didTappedShowAllImages()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
