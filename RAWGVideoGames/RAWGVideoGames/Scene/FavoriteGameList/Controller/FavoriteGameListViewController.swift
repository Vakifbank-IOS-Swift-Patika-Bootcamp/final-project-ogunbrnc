//
//  FavoriteGameListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit

class FavoriteGameListViewController: UIViewController {

    @IBOutlet weak var favoriteGamesTableView: UITableView! {
        didSet {
            favoriteGamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            favoriteGamesTableView.delegate = self
            favoriteGamesTableView.dataSource = self
            favoriteGamesTableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
}

extension FavoriteGameListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as UITableViewCell
        cell.textLabel?.text = "dummy text"
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
