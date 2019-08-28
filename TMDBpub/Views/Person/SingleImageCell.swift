//
//  SingleImageCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 28/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class SingleImageCell: BaseImageCell {
    
    let imageView = UIImageView(cornerRadius: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = .white
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    override var isHighlighted: Bool {
        didSet {
            var transform: CGAffineTransform = .identity
            if isHighlighted {
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.transform = transform
                
            })
        }
    }
    
    func configureCell(profile: ImageStruct) {
        guard let filePath = profile.file_path else { return }
        let imageUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: filePath, posterSize: Constants.PersonImageSize.w220_and_h330_face.rawValue))
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: imageUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
