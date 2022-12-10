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
            favoriteGamesTableView.register(FavoriteGameListTableViewCell.self, forCellReuseIdentifier: FavoriteGameListTableViewCell.identifier)
            favoriteGamesTableView.delegate = self
            favoriteGamesTableView.dataSource = self
            favoriteGamesTableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    private var viewModel: FavoriteGameListViewModelProtocol = FavoriteGameListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchGames()
    }
}

extension FavoriteGameListViewController: FavoriteGameListViewModelDelegate {
    func gamesLoaded() {
        favoriteGamesTableView.reloadData()
    }
}

extension FavoriteGameListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteGameListTableViewCell.identifier,for: indexPath) as? FavoriteGameListTableViewCell,
              let model = viewModel.getGame(at: indexPath.row) else { return UITableViewCell() }
       cell.configureCell(game: model)
       return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

