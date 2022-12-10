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
    func getGame(at index: Int) -> GameModel?
    func getGameId(at index: Int) -> Int?
}

protocol FavoriteGameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

final class FavoriteGameListViewModel: FavoriteGameListViewModelProtocol {
    weak var delegate: FavoriteGameListViewModelDelegate?
    private var games: [GameModel]?


    func fetchGames() {
        games = []
        delegate?.gamesLoaded()
    }
    
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        games?[index].id
    }
    
}
