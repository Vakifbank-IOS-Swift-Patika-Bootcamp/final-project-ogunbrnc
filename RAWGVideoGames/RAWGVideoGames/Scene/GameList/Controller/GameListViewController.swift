//
//  GameListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

final class GameListViewController: UIViewController {
    
    private let searchController = UISearchController()
    
    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.register(GameListTableViewCell.self, forCellReuseIdentifier: GameListTableViewCell.identifier)
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
            gameListTableView.estimatedRowHeight = UITableView.automaticDimension

        }
    }
    
    private var viewModel: GameListViewModelProtocol = GameListViewModel()
    
    
    
    private func configureSearchController(){
       navigationItem.searchController = searchController
       searchController.searchResultsUpdater = self
       searchController.searchBar.delegate = self
           
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchGames()
        
        configureSearchController()
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

extension GameListViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        if !(text.isEmpty) {
            viewModel.searchGame(with: text)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        guard let text = searchBar.text else {
            return
        }
        if !(text.isEmpty) {
            viewModel.searchGame(with: text)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        viewModel.searchGameCancel()
    }
}
