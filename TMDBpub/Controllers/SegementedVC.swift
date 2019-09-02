//
//  SegmentedVC.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 02/09/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SegmentedVC: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies", "Persons"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    @objc fileprivate func handleSegmentChange() {
        print(segmentedControl.selectedSegmentIndex)
        updateView()
    }
    
//    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
//    var segmentControl: UISegmentedControl!
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()

    private lazy var searchMovieViewController: SearchMovieController = {
        // Instantiate View Controller
        var viewController = SearchMovieController()
        
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        
        return viewController
    }()
    
    private lazy var searchPersonViewController: SearchMovieController = {
        // Instantiate View Controller
        var viewController = SearchMovieController()
        
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        
        return viewController
    }()
    
//    static func viewController() -> SegmentedVC {
//        let vc = SegmentedVC()
//        return vc
//    }
//        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SegementedView") as! SegementedVC
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
//        setupSearchBar()
        
        setupView()
    }
    
    fileprivate func setupUI() {
        
        self.navigationItem.titleView = segmentedControl
        
//        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
//        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
//        paddedStackView.isLayoutMarginsRelativeArrangement = true
        
        let stackView = UIStackView(arrangedSubviews: [
//            paddedStackView,
            containerView
            ])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero)
    }
    
//    fileprivate func setupSearchBar() {
//        definesPresentationContext = true
//        navigationItem.searchController = self.searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//        searchController.searchBar.becomeFirstResponder()
//    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    fileprivate func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: searchPersonViewController)
            add(asChildViewController: searchMovieViewController)
        } else {
            remove(asChildViewController: searchMovieViewController)
            add(asChildViewController: searchPersonViewController)
        }
    }
    
    func setupView() {
        updateView()
    }
    
}
