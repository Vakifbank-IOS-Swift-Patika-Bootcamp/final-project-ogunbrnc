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
    func fetchSearchedGames(with text: String)
    func fetchSearchedGamesCancel()
    func isSearching() -> Bool
    func getSortingOptions() -> [String]
    func getGameCount() -> Int
    func getGame(at index: Int) -> GameModel?
    func getGameId(at index: Int) -> Int?
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesLoaded()
    func gamesLoadingError(error: Error)
}

final class GameListViewModel: GameListViewModelProtocol {
    
    weak var delegate: GameListViewModelDelegate?
    private var searching: Bool = false
    private var sortParam: String = ""
    private var searchParam: String = ""
    private var nextURL: String? = ""
    private var games: [GameModel] = []
    private var tempGames: [GameModel] = []
    private let sortingOptionsMapping: [String:String] = [
        "Relevance".localized():"relevance",
        "Date added".localized():"created",
        "Name".localized():"name",
        "Release date".localized():"released",
        "Popularity".localized():"added",
        "Average rating".localized():"rating",
    ]
    
    func getSortingOptions() -> [String] {
        return [String] (sortingOptionsMapping.keys)
    }
    
    func fetchGames() {
        guard let nextURL = nextURL else { return }
        Client.getGames(by:sortParam,with: nextURL){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                self.nextURL = responseModel.next
                self.games.append(contentsOf: responseModel.results)
                self.delegate?.gamesLoaded()
            case .failure(let error):
                self.delegate?.gamesLoadingError(error: error)
            }
        }
    }
    
    func fetchGamesSorted(by filter: String) {
        guard let sortParam = sortingOptionsMapping[filter] else { return }
        self.sortParam = sortParam
        nextURL = ""
        
        games = []
        fetchGames()
    }
    
    func fetchSearchedGames(with text: String) {
        searching = true
        if !text.isEmpty {
            searchParam = text.replacingOccurrences(of: " ", with: "").lowercased()
        }
        guard let nextURL = nextURL else { return }
        Client.getGames(with: nextURL,search: searchParam){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                self.nextURL = responseModel.next
                if text.isEmpty {
                    self.games.append(contentsOf: responseModel.results)
                }
                else {
                    self.games = responseModel.results
                }
                self.delegate?.gamesLoaded()
            case .failure(let error):
                self.delegate?.gamesLoadingError(error: error)
            }
        }
    }
    
    func fetchSearchedGamesCancel() {
        searching = false
        nextURL = ""
        sortParam = ""
        games = []
        
        fetchGames()
    }
    
    func isSearching() -> Bool {
        searching
    }
    
    func getGameCount() -> Int {
        games.count
    }
    
    func getGame(at index: Int) -> GameModel? {
        games[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        games[index].id
    }
}
