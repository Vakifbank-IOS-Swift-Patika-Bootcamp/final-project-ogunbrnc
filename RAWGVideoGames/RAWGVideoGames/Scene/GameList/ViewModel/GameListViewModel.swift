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
//This default text value is for the pagination. We will call fetchSearchedGames function with no argument to fetch more data with same searchParam
extension GameListViewModelProtocol {
    func fetchSearchedGames(with text: String = ""){ fetchSearchedGames(with: text) }
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesLoaded()
    func gamesLoadingError(error: Error)
}

final class GameListViewModel: GameListViewModelProtocol {
    
    weak var delegate: GameListViewModelDelegate?
    private var searching: Bool
    private var sortParam: String
    private var searchParam: String
    private var nextURL: String?
    private var games: [GameModel]
    private let sortingOptionsMapping: [String:String] = [
        "Relevance".localized():"relevance",
        "Date added".localized():"created",
        "Name".localized():"name",
        "Release date".localized():"released",
        "Popularity".localized():"added",
        "Average rating".localized():"rating",
    ]
    
    init(games: [GameModel] = [],
         nextURL: String? = "",
         searchParam: String = "",
         sortParam: String = "",
         searching: Bool = false ) {
        self.games = games
        self.nextURL = nextURL
        self.searchParam = searchParam
        self.sortParam = sortParam
        self.searching = searching
    }
    
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
        //if we call fetchSearchedGames function to get more game with same search param, this will be empty and we will use current searchParam
        if !text.isEmpty {
            searchParam = text.replacingOccurrences(of: " ", with: "-").lowercased()
        }
        guard let nextURL = nextURL else { return }
        Client.getGames(with: nextURL,search: searchParam){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                self.nextURL = responseModel.next
                //we get more data for the same search param.
                if text.isEmpty {
                    self.games.append(contentsOf: responseModel.results)
                }
                //we searched for the first time.
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
        self.searching = false
        self.nextURL = ""
        
        self.games = []
        fetchGames()
    }
    
    func isSearching() -> Bool {
        searching
    }
    
    func getGameCount() -> Int {
        games.count
    }
    
    func getGame(at index: Int) -> GameModel? {
        if games.count > index {
            return games[index]
        }
        return nil
    }
    
    func getGameId(at index: Int) -> Int? {
        if games.count > index {
            return games[index].id
        }
        return nil
    }
}
