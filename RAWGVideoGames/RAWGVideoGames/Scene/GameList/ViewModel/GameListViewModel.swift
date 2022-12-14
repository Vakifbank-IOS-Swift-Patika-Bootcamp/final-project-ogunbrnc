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
    func fetchMoreGames()
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
    private var nextURL: String?
    private var games: [GameModel] = []
    private var filteredGames: [GameModel] = []
    private let sortingOptionsMapping: [String:String] = [
        "Relevance".localized():"relevance",
        "Date added".localized():"created",
        "Name".localized():"name",
        "Release date".localized():"released",
        "Popularity".localized():"added",
        "Average rating".localized():"rating",
    ]
    
    func searchGame(with text: String) {
        filteredGames = games.filter {
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
        Client.getGames(){ [weak self] result in
            guard let self = self else { return }
            self.handleGetGamesResponse(result: result)
        }
    }
    
    func fetchMoreGames(){
        guard let nextURL = nextURL else { return }
        Client.getGames(with: nextURL){ [weak self] result in
            guard let self = self else { return }
            self.handleGetGamesResponse(result: result)
            
        }
   }
    
    private func handleGetGamesResponse(result: Result<GetGamesResponseModel, Error>) {
        switch result {
        case .success(let responseModel):
            self.nextURL = responseModel.next
            self.games.append(contentsOf: responseModel.results)
            self.filteredGames.append(contentsOf: responseModel.results)
            self.delegate?.gamesLoaded()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func fetchGamesSorted(by filter: String) {
        let sortedParam = sortingOptionsMapping[filter]
        Client.getGamesSorted(by: sortedParam!){ [weak self] games, error in
            guard let self = self, let games = games else { return }
            self.games.append(contentsOf: games)
            self.filteredGames.append(contentsOf: games)
            self.delegate?.gamesLoaded()
        }
        
    }
    
    func getGameCount() -> Int {
        filteredGames.count
    }
    
    func getGame(at index: Int) -> GameModel? {
        filteredGames[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        filteredGames[index].id
    }
    
}
