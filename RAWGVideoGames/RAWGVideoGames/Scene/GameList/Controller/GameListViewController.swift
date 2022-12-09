//
//  GameListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

final class GameListViewController: UIViewController {
    
    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.register(GameListTableViewCell.self, forCellReuseIdentifier: GameListTableViewCell.identifier)
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
            gameListTableView.estimatedRowHeight = UITableView.automaticDimension

        }
    }
    
    private var viewModel: GameListViewModelProtocol = GameListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchGames()
    }
}

extension GameListViewController: GameListViewModelDelegate {
    func gamesLoaded() {
        gameListTableView.reloadData()
    }
}

extension GameListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameListTableViewCell",for: indexPath) as? GameListTableViewCell, let model = viewModel.getGame(at: indexPath.row) else { return UITableViewCell() }
       cell.configureCell(game: model)
       return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    
    
}
