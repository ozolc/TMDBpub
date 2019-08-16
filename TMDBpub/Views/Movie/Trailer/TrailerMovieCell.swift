//
//  TrailerMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 15/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import WebKit
import UIKit.UIGestureRecognizerSubclass

protocol TrailerCellDelegate: class {
    func didTrailerImageTapped(sender: TrailerMovieCell)
}

class UIShortTapGestureRecognizer: UITapGestureRecognizer {
    let tapMaxDelay: Double = 0.3 //anything below 0.3 may cause doubleTap to be inaccessible by many users
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + tapMaxDelay) { [weak self] in
            if self?.state != UIGestureRecognizer.State.recognized {
                self?.state = UIGestureRecognizer.State.failed
            }
        }
    }
}

class TrailerMovieCell: UICollectionViewCell {
    
    var selectedCell: Int! {
        didSet {
            thumbnailImageView.tag = selectedCell
        }
    }
    weak var delegate: TrailerCellDelegate?
    
    var video: VideoResult! {
        didSet {
            nameLabel.text = video.name
            typeLabel.text = video.type
            
            let urlString = Constants.imageYoutubeBaseURL + video.key + "/0.jpg"
            if let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
            }
        }
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.moviePosterPlaceholderImageName)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        let tapGestureRecognizer = UIShortTapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let cell = touch?.view?.superview?.superview as? TrailerMovieCell {
            delegate?.didTrailerImageTapped(sender: cell)
        }
    }
    
    
    @objc fileprivate func handleImageTapped() {
        delegate?.didTrailerImageTapped(sender: self)
    }
    
    fileprivate func setupLayout() {
        let titleStackView = VerticalStackView(arrangedSubviews: [nameLabel, typeLabel, UIView()], spacing: 4)
        titleStackView.constrainHeight(constant: 50)
        titleStackView.alignment = .center
        
        let overallStackView = VerticalStackView(arrangedSubviews: [thumbnailImageView, titleStackView])
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        addSeparator(at: [.bottom],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 0, left: 16, bottom: -5, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
