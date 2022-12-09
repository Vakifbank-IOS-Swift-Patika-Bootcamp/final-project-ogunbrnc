//
//  GameListViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? { get set }
    func fetchGames()
    func searchGame(with text: String)
    func searchGameCancel()
    func getGameCount() -> Int
    func getGame(at index: Int) -> GameModel?
    func getGameId(at index: Int) -> Int?
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

final class GameListViewModel: GameListViewModelProtocol {
    
    weak var delegate: GameListViewModelDelegate?
    private var games: [GameModel]?
    private var filteredGames: [GameModel]?
    
   
    
    func searchGame(with text: String) {
        filteredGames = games?.filter {
            $0.name.replacingOccurrences(of: " ", with: "").lowercased().contains(text.replacingOccurrences(of: " ", with: "").lowercased())}
        delegate?.gamesLoaded()
    }
    
    func searchGameCancel() {
        filteredGames = games
        delegate?.gamesLoaded()
    }
    
    func fetchGames() {
        Client.getGames { [weak self] games, error in
            guard let self = self else { return }
            self.games = games
            self.filteredGames = games
            self.delegate?.gamesLoaded()
        }
    }
    
    func getGameCount() -> Int {
        filteredGames?.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        filteredGames?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        filteredGames?[index].id
    }
    
}
