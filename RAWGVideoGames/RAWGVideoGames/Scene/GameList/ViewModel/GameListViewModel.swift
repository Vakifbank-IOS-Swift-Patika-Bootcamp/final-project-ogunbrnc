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
    func fetchGamesSorted(by filter: String)
    func searchGame(with text: String)
    func searchGameCancel()
    func getSortingOptions() -> [String]
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
    private let sortingOptionsMapping: [String:String] = [
        "Relevance".localized():"relevance",
        "Date added".localized():"created",
        "Name".localized():"name",
        "Release date".localized():"released",
        "Popularity".localized():"added",
        "Average rating".localized():"rating",
    ]
    
   
    
    func searchGame(with text: String) {
        filteredGames = games?.filter {
            $0.name.replacingOccurrences(of: " ", with: "").lowercased().contains(text.replacingOccurrences(of: " ", with: "").lowercased())}
        delegate?.gamesLoaded()
    }
    
    func searchGameCancel() {
        filteredGames = games
        delegate?.gamesLoaded()
    }
    
    func getSortingOptions() -> [String] {
        return [String] (sortingOptionsMapping.keys)
    }
    
    func fetchGames() {
        Client.getGames { [weak self] games, error in
            guard let self = self else { return }
            self.games = games
            self.filteredGames = games
            self.delegate?.gamesLoaded()
        }
    }
    func fetchGamesSorted(by filter: String) {
        let sortedParam = sortingOptionsMapping[filter]
        Client.getGamesSorted(by: sortedParam!){ [weak self] games, error in
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
