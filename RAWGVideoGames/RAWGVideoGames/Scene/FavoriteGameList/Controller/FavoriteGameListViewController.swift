//
//  FavoriteGameListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit

class FavoriteGameListViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var favoriteGamesTableView: UITableView! {
        didSet {
            favoriteGamesTableView.register(FavoriteGameListTableViewCell.self, forCellReuseIdentifier: FavoriteGameListTableViewCell.identifier)
            favoriteGamesTableView.delegate = self
            favoriteGamesTableView.dataSource = self
            favoriteGamesTableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: UI Components
    private let noFavoriteGameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There are no games in your favorite list.\n You can add games to favorite list using detail page.".localized()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    // MARK: Variable Declarations
    private var viewModel: FavoriteGameListViewModelProtocol = FavoriteGameListViewModel()

    // MARK: UI Configurations
    private func configureNoNoteLabel(){
        if viewModel.getGameCount() == 0 {
            view.addSubview(noFavoriteGameLabel)
            noFavoriteGameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            noFavoriteGameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            noFavoriteGameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        }
    }
    
    private func configureNotificationCenters() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteGameAdded), name: NSNotification.Name(rawValue: "FavoriteGameAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteGameDeleted), name: NSNotification.Name(rawValue: "FavoriteGameDeleted"), object: nil)
    }

    // MARK: Selector Functions
    @objc func favoriteGameAdded(_ notification: NSNotification) {
        //game is added to the favorite list for the first time
        if viewModel.getGameCount() == 0 {
            noFavoriteGameLabel.removeFromSuperview()
        }
        if let favoriteGame = notification.userInfo?["favoriteGame"] as? FavoriteGame {
            viewModel.newGameAddedToFavorites(game: favoriteGame)
        }
        
    }
    
    @objc private func favoriteGameDeleted() {
        viewModel.gameDeletedFromFavorites()
        //last game in the list has been deleted from the favorite list
        if viewModel.getGameCount() == 0 {
            configureNoNoteLabel()
        }
    }
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchGames()
        configureNotificationCenters()
        configureNoNoteLabel()
    }
    
}
// MARK: FavoriteGameListViewModelDelegate Extension
extension FavoriteGameListViewController: FavoriteGameListViewModelDelegate {
    func gamesLoaded() {
        favoriteGamesTableView.reloadData()
    }
}

// MARK: TableView Delegate, DataSource Extension
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameDetailViewController") as? GameDetailViewController else { return }
        detailVC.gameId = viewModel.getGameId(at: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteGameFromFavoriteList(index: indexPath.row) { result in
                if result {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    configureNoNoteLabel()
                }
                else {
                    return
                }
        }
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}

