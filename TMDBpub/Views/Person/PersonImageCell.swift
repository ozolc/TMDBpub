//
//  PersonImageCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 28/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonImageCell: UICollectionViewCell {
    
    let imagePersonLabel = UILabel(text: "Изображения", font: .boldSystemFont(ofSize: 20))
    let horizontalController = PreviewScreenshotController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    addSubview(imagePersonLabel)
    addSubview(horizontalController.view)
    
    imagePersonLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
    horizontalController.view.anchor(top: imagePersonLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
