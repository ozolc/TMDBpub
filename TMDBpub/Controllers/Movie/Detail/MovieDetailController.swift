//
//  MovieDetailController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MovieDetailController: UITableViewController {
    
    fileprivate let movie: Movie
    
    // dependency injection constructor
    init(movie: Movie) {
        self.movie = movie
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: cellId)
        
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MovieDetailCell
        cell.movie = movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
}
