//
//  MovieDetailToolCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailTool: UITableViewCell {
    
    var reviews: Review! {
        didSet {
//            print("Reviews:",reviews.id)
        }
    }
    
    let reviewView: UIView = {
        let view = UIView()
        view.constrainHeight(constant: 60)
        view.constrainWidth(constant: 60)
        return view
    }()
    
    let reviewsImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "reviews"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        setupLayout()
    }
    
    fileprivate func createButtonView(withImage image: UIImage, andCaption text: String) -> UIView {
//        let wrapperView: UIView = {
//            let view = UIView()
//            view.constrainHeight(constant: 50)
//            view.constrainWidth(constant: 50)
//            return view
//        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .black
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.text = text
            return label
        }()
        
        let imageView: UIImageView = {
            let iv = UIImageView(image: image)
            iv.contentMode = .scaleAspectFit
            return iv
        }()
        
        let verticalStackView = VerticalStackView(arrangedSubviews: [imageView, titleLabel], spacing: 2)
        verticalStackView.alignment = .center
        verticalStackView.constrainHeight(constant: 60)
        
        verticalStackView.addSeparator(at: [ .top, .bottom, .right],
                                color: UIColor.init(white: 0.75, alpha: 1),
                                weight: 2,
                                insets: .init(top: -4, left: -2, bottom: -4, right: -4))
//        wrapperView.addSubview(imageView)
//        wrapperView.fillSuperview(padding: .init(top: 4, left: 4, bottom: 4, right: 4))
        return verticalStackView
    }
    
    fileprivate func setupLayout() {
        let toolsStackView = UIStackView(arrangedSubviews: [
            createButtonView(withImage: #imageLiteral(resourceName: "reviews"), andCaption: "Reviews"),
            createButtonView(withImage: #imageLiteral(resourceName: "cast"), andCaption: "Credits"),
            createButtonView(withImage: #imageLiteral(resourceName: "playVideo"), andCaption: "Trailers"),
            createButtonView(withImage: #imageLiteral(resourceName: "similarMovies"), andCaption: "Similars")
            ])
        
        toolsStackView.distribution = .fillEqually
        toolsStackView.addSeparator(at: [.right],
                          color: UIColor.white,
                          weight: 2,
                          insets: .init(top: -2, left: -2, bottom: -2, right: -4))
        
        addSubview(toolsStackView)
        toolsStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
//        toolsStackView.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
