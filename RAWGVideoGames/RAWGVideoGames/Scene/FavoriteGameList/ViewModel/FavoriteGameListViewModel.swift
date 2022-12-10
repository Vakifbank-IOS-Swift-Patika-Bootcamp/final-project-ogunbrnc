//
//  FavoriteGameListViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import Foundation

protocol FavoriteGameListViewModelProtocol {
    var delegate: FavoriteGameListViewModelDelegate? { get set }
    func fetchGames()
    func getGameCount() -> Int
    func getGame(at index: Int) -> FavoriteGame?
    func getGameId(at index: Int) -> Int?
}

protocol FavoriteGameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

final class FavoriteGameListViewModel: FavoriteGameListViewModelProtocol {
    weak var delegate: FavoriteGameListViewModelDelegate?
    private var games: [FavoriteGame]?


    func fetchGames() {
        games = CoreDataManager.shared.getFavoriteGames()
        print(games)
        delegate?.gamesLoaded()
    }
    
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> FavoriteGame? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        5
    }
    
}
