//
//  AccountTableViewController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 22/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    lazy var authManager = AuthenticationManager()
    
    let accountLists: [AccountListMovie] = [
        AccountListMovie(name: "Избранное", path: .AccountFavorites.self),
        AccountListMovie(name: "Отслеживаемое", path: .AccountWatchlist.self)
    ]
    
    fileprivate var user: User!
    fileprivate let navBarHeight: CGFloat = 150
    
    let topCellId = "topCellId"
    let middleCellId = "middleCellId"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.setRightBarButton(logoutButton, animated: true)
    }
    
    @objc private func handleLogout() {
        authManager.deleteCurrentUser()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    fileprivate func setUpTableView() {
        tableView.backgroundColor = .white
        tableView.register(AccountTopCell.self,forCellReuseIdentifier: topCellId)
        tableView.register(AccountMiddleCell.self,forCellReuseIdentifier: middleCellId)
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            var controller = UICollectionViewController()
            let list = accountLists[indexPath.row]
            var path = ""
            
            switch indexPath.row {
            case 0:
                path = list.path.description
            case 1:
                path = list.path.description
            default:
                break
            }
            
            let favoriteTypeOfRequest = Constants.Account + "/" + Constants.accountId + "/" + path
            print(favoriteTypeOfRequest)
            controller = GenericMoviesControllers(nil, typeOfRequest: favoriteTypeOfRequest, sessionId: Constants.sessionId)
            controller.navigationItem.title = list.name.firstCapitalized
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : accountLists.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: topCellId, for: indexPath) as? AccountTopCell else {
                return UITableViewCell(style: .default, reuseIdentifier: nil)
            }
        cell.user = globalUser
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: middleCellId, for: indexPath) as! AccountMiddleCell
            let accountList = accountLists[indexPath.row]
            cell.accountList = accountList
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
