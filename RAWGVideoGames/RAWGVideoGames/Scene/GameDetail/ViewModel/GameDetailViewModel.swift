//
//  GameDetailViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import Foundation

protocol GameDetailViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? { get set }
    func fetchGameDetail(id: Int)
    func getGameImageURL() -> URL?
    func getGameName() -> String
    func getGamePlatform() -> String
    func getGameGenre() -> String
    func getGameReleaseDate() -> String
    func getGameTag() -> String
    func getGameDescription() -> String
    func isItFavoriteGame() -> Bool
    func addGameToFavoriteList(completion: (Bool) -> ())
    func deleteGameFromFavoriteList(completion: (Bool) -> ())

}

protocol GameDetailViewModelDelegate: AnyObject {
    func gameLoaded()
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    
    weak var delegate: GameDetailViewModelDelegate?
    private var game: GameDetailModel?
    
    func fetchGameDetail(id: Int) {
        Client.getGameDetail(movieId: id) { [weak self] gameDetail, error in
            guard let self = self else { return }
            self.game = gameDetail
            self.delegate?.gameLoaded()
        }
    }
    
    func getGameImageURL() -> URL? {
        URL(string: game?.imageURL ?? "")
    }
    
    func getGameName() -> String {
        game?.name ?? ""

    }
    
    func getGamePlatform() -> String {
        game?.parentPlatforms.map{$0.platform.name}.joined(separator: "\n") ?? ""
    }
    
    func getGameGenre() -> String {
        game?.genres.map{$0.name}.joined(separator: "\n") ?? ""
    }
    
    func getGameReleaseDate() -> String {
        game?.releaseDate ?? ""
    }
    
    func getGameTag() -> String {
        let tagCount = 5
        return game?.tags[0..<tagCount].map{$0.name}.joined(separator: "\n") ?? ""
    }
    
    func getGameDescription() -> String {
        game?.descriptionRaw ?? ""
    }
    
    func isItFavoriteGame() -> Bool {
        return CoreDataManager.shared.isFavorite(id: game!.id)
    }
    
    func addGameToFavoriteList(completion: (Bool) -> ()) {
        if CoreDataManager.shared.addToFavorite(id: game!.id, gameName: game!.name, gameImageURL: game!.imageURL) {
            completion(true)
        } else {
            completion(false)
        }
    }
    func deleteGameFromFavoriteList(completion: (Bool) -> ()) {
        if CoreDataManager.shared.deleteFromFavorite(id: game!.id) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
}
