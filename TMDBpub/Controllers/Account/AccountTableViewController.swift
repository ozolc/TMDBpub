//
//  AccountTableViewController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 22/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    fileprivate var user: User!
    fileprivate let navBarHeight: CGFloat = 150
    
    let topCellId = "topCellId"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    fileprivate func setUpTableView() {
        tableView.backgroundColor = .white
        tableView.register(AccountTopCell.self,forCellReuseIdentifier: topCellId)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 120 : 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: topCellId, for: indexPath) as? AccountTopCell else {
                return UITableViewCell(style: .default, reuseIdentifier: "cellId")
            }
        cell.user = globalUser
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            cell.textLabel?.text = "Article \(indexPath.row)"
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "cellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

//class AccountViewController: UIViewController, UITableViewDelegate {
//
//    fileprivate var user: User!
//    fileprivate lazy var customNavBar = AccountNavBar(user: globalUser)
//        fileprivate let navBarHeight: CGFloat = 150
//    var tableView: UITableView!
//    var headerHeightConstraint:NSLayoutConstraint!
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchData()
//
//        setUpHeader()
//        setUpTableView()
//        setupUI()
//    }
//
//    fileprivate func fetchData() {
//        LoaderController.shared.showLoader()
//        APIService.shared.fetchMoviesStat(typeOfRequest: Constants.Account, sessionID:  Constants.sessionId) { (user: User) in
//            print(user)
//            self.user = user
//            LoaderController.shared.removeLoader()
//        }
//    }
//
//    fileprivate func setupUI() {
////                let statusBarCover = UIView(backgroundColor: .yellow)
////                view.addSubview(statusBarCover)
////                statusBarCover.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
//    }
//
//    fileprivate func setUpHeader() {
//        view.addSubview(customNavBar)
//        headerHeightConstraint = customNavBar.heightAnchor.constraint(equalToConstant: 150)
//        customNavBar.translatesAutoresizingMaskIntoConstraints = false
//        headerHeightConstraint.isActive = true
//
//        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
//    }
//
//    fileprivate func setUpTableView() {
//        tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//
//        tableView.alwaysBounceVertical = true
//        tableView.backgroundColor = .white
//
//        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        tableView.anchor(top: customNavBar.bottomAnchor,
//                         leading: view.safeAreaLayoutGuide.leadingAnchor,
//                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                         trailing: view.safeAreaLayoutGuide.trailingAnchor)
//
////        tableView.contentInset.top = navBarHeight
////        tableView.scrollIndicatorInsets.top = navBarHeight
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError()
//    }
//}
//
//extension AccountViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Article \(indexPath.row)"
//        return cell
//    }
//
//}
//
//extension AccountViewController: UIScrollViewDelegate {
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        if scrollView.contentOffset.y < 0 {
////            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
////        }
////    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//    }
//}
