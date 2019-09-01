//
//  TestViewController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 01/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let ratingStackView = RatingControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        ratingStackView.backgroundColor = .yellow
        ratingStackView.spacing = 8
        
        view.addSubview(ratingStackView)
        ratingStackView.centerInSuperview()
        
    }
    
}
