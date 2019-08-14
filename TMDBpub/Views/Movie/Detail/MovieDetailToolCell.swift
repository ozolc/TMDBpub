//
//  MovieDetailToolCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 14/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol MovieDetailToolCellDelegate: class {
    // Method used to tell the delegate that the button was pressed in the subview.
    // You can add parameters here as you like.
    func reviewButtonPressed(sender: MovieDetailToolCell)
    func castButtonPressed(sender: MovieDetailToolCell)
}

class MovieDetailToolCell: UITableViewCell {
    
    // Define the view's delegate.
    weak var delegate: MovieDetailToolCellDelegate?
    
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
    
    fileprivate func createButtonView(withImage image: UIImage, andCaption text: String, action: Selector) -> UIButton {
        
        let titleButton: UIButton = {
            let button = UIButton()
            button.setTitle(text, for: .normal)
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.alignTextUnderImage()
            button.addTarget(self, action: action, for: .touchUpInside)
            return button
        }()
        
        titleButton.addSeparator(at: [ .top, .bottom, .right],
                                       color: UIColor.init(white: 0.75, alpha: 1),
                                       weight: 2,
                                       insets: .init(top: -4, left: -2, bottom: -4, right: 0))
        
        return titleButton
    }
    
    fileprivate func setupLayout() {
        let toolsStackView = UIStackView(arrangedSubviews: [
            createButtonView(withImage: #imageLiteral(resourceName: "reviews"), andCaption: "Отзывы", action: #selector(handleReviewTapped)),
            createButtonView(withImage: #imageLiteral(resourceName: "cast"), andCaption: "Состав", action: #selector(handleCastTapped)),
            createButtonView(withImage: #imageLiteral(resourceName: "playVideo"), andCaption: "Трейлеры", action: #selector(handleReviewTapped)),
            createButtonView(withImage: #imageLiteral(resourceName: "similarMovies"), andCaption: "Похожие", action: #selector(handleReviewTapped))
            ])
        
        toolsStackView.distribution = .fillEqually
        toolsStackView.addSeparator(at: [.right],
                          color: UIColor.white,
                          weight: 2,
                          insets: .init(top: -2, left: -4, bottom: -2, right: 0))
        toolsStackView.constrainHeight(constant: 100)
        
        addSubview(toolsStackView)
        toolsStackView.fillSuperview(padding: .init(top: 4, left: 16, bottom: 16, right: 16))
    }
    
    @objc fileprivate func handleReviewTapped() {
        delegate?.reviewButtonPressed(sender: self)
    }
    
    @objc fileprivate func handleCastTapped() {
        delegate?.castButtonPressed(sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
