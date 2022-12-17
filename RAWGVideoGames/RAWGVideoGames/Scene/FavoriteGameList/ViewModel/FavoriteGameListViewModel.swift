//
//  FavoriteGameListViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import Foundation

protocol FavoriteGameListViewModelProtocol {
    var delegate: FavoriteGameListViewModelDelegate? { get set }
    func newGameAddedToFavorites(game: FavoriteGame)
    func gameDeletedFromFavorites()
    func fetchGames()
    func getGameCount() -> Int
    func getGame(at index: Int) -> FavoriteGame?
    func getGameId(at index: Int) -> Int?
    func deleteGameFromFavoriteList(index: Int, completion: (Bool) -> ())
}

protocol FavoriteGameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

final class FavoriteGameListViewModel: FavoriteGameListViewModelProtocol {
    weak var delegate: FavoriteGameListViewModelDelegate?
    private var games: [FavoriteGame]?
    private var databaseManager: DatabaseManager
    
    init(games: [FavoriteGame]? = nil, databaseManager: DatabaseManager = CoreDataManager.shared) {
        self.games = games
        self.databaseManager = databaseManager
    }

    func newGameAddedToFavorites(game: FavoriteGame) {
        games?.append(game)
        delegate?.gamesLoaded()
    }
    
    func gameDeletedFromFavorites() {
        //since game id is equal to 0 after deletion from coredata, we remove the one whose id is equal to zero.
        if let index = games?.enumerated().filter({$0.element.gameId == 0}).map({$0.offset}).first {
            games?.remove(at: index)
            delegate?.gamesLoaded()
        }
    }
    
    func deleteGameFromFavoriteList(index: Int, completion: (Bool) -> ()) {
        guard let gameId = getGameId(at: index) else { completion(false); return }
        if databaseManager.deleteFromFavorite(id: gameId) {
            games?.remove(at: index)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavoriteGameDeletedInList"), object: nil, userInfo: nil)
            completion(true)
        } else {
            completion(false)
        }
    }

    func fetchGames() {
        games = databaseManager.getFavoriteGames()
        delegate?.gamesLoaded()
    }
    
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> FavoriteGame? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        Int(games![index].gameId)
    }
    
}
