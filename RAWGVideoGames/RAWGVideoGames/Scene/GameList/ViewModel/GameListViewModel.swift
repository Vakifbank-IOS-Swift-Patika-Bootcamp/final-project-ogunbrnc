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
    func isSearching() -> Bool
    func searchGame(with text: String)
    func searchGameCancel()
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
    private var nextURL: String? = ""
    private var games: [GameModel] = []
    private var searchedGames: [GameModel] = []
    private let sortingOptionsMapping: [String:String] = [
        "Relevance".localized():"relevance",
        "Date added".localized():"created",
        "Name".localized():"name",
        "Release date".localized():"released",
        "Popularity".localized():"added",
        "Average rating".localized():"rating",
    ]
    
    func isSearching() -> Bool {
        searching
    }
    
    func searchGame(with text: String) {
        searching = true
        searchedGames = games.filter {
            $0.name.replacingOccurrences(of: " ", with: "").lowercased().contains(text.replacingOccurrences(of: " ", with: "").lowercased())}
        delegate?.gamesLoaded()
    }
    
    func searchGameCancel() {
        searching = false
        searchedGames = games
        delegate?.gamesLoaded()
    }
    
    func getSortingOptions() -> [String] {
        return [String] (sortingOptionsMapping.keys)
    }
    
    func fetchGames() {
        guard let nextURL = nextURL else { return }
        Client.getGames(with: nextURL){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                self.nextURL = responseModel.next
                self.games.append(contentsOf: responseModel.results)
                self.searchedGames.append(contentsOf: responseModel.results)
                self.delegate?.gamesLoaded()
            case .failure(let error):
                self.delegate?.gamesLoadingError(error: error)
            }
        }
    }
    
    func fetchGamesSorted(by filter: String) {
        guard let sortedParam = sortingOptionsMapping[filter] else { return }
        Client.getGames(by: sortedParam,with: ""){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                self.nextURL = responseModel.next
                self.games = responseModel.results
                self.searchedGames = responseModel.results
                self.delegate?.gamesLoaded()
            case .failure(let error):
                self.delegate?.gamesLoadingError(error: error)
            }
        }
    }
    
    func getGameCount() -> Int {
        searchedGames.count
    }
    
    func getGame(at index: Int) -> GameModel? {
        searchedGames[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        searchedGames[index].id
    }
}
