//
//  PhotoCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 29/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    
    var personImage: ImageStruct! {
        didSet {
            imageView.sd_setImage(with: URL(string: personImage.file_path ?? ""))
            print(personImage.file_path ?? "")
        }
    }
    
    func configureCell(personImage: ImageStruct) {
        guard let filePath = personImage.file_path else { return }
        let imageUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: filePath, posterSize: Constants.PersonImageSize.w300_and_h450_bestv2.rawValue))
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: imageUrl)
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
