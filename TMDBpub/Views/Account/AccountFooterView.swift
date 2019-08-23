//
//  AccountFooterView.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 23/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AccountFooterView: UITableViewHeaderFooterView {
    
    private lazy var authManager = AuthenticationManager()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let logoutButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Log Out", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//            button.backgroundColor = .lightGray
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
//            button.layer.cornerRadius = 22
            button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
            return button
        }()
        
        addSubview(logoutButton)
        logoutButton.centerInSuperview()
    }
    
    @objc private func handleLogout() {
        authManager.deleteCurrentUser()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
