//
//  TrailerMovieCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 15/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import WebKit

class TrailerMovieCell: UICollectionViewCell {
    
    var video: VideoResult! {
        didSet {
            nameLabel.text = video.name
            typeLabel.text = video.type
            
//            loadYoutube(videoID: video.key)
            
            let urlString = Constants.imageYoutubeBaseURL + video.key + "/0.jpg"
            if let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
            }
        }
    }
    
    lazy var webConfiguration: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        return config
    }()
    
    lazy var wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
//        label.numberOfLines = 1
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
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    func loadYoutube(videoID: String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1")
            else { return }
        wkWebView.load( URLRequest(url: youtubeURL) )
        print(youtubeURL.absoluteString)
    }
    
    fileprivate func setupLayout() {
        let titleStackView = VerticalStackView(arrangedSubviews: [nameLabel, typeLabel, UIView()], spacing: 4)
        titleStackView.constrainHeight(constant: 50)
        titleStackView.alignment = .center
//        titleStackView.distribution = .fillEqually
//        titleStackView.backgroundColor = .yellow
        
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
