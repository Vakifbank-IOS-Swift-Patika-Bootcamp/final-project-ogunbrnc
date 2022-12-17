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
    func getGameRatingExceptionalCount() -> Int
    func getGameRatingRecommendedCount() -> Int
    func getGameRatingMehCount() -> Int
    func getGameRatingSkipCount() -> Int
    func getGameRatingAverage() -> Double
    func getGameTime() -> Int
    func getGameRatingCount() -> Int
    func isItFavoriteGame() -> Bool
    func addGameToFavoriteList(completion: (Bool) -> ())
    func deleteGameFromFavoriteList(completion: (Bool) -> ())

}

protocol GameDetailViewModelDelegate: AnyObject {
    func gameLoaded()
    func gameLoadingError(error: Error)
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    
    weak var delegate: GameDetailViewModelDelegate?
    private var game: GameDetailModel?
    private var databaseManager: DatabaseManager
    
    init(game: GameDetailModel? = nil, databaseManager: DatabaseManager = CoreDataManager.shared) {
        self.game = game
        self.databaseManager = databaseManager
    }
    
    func fetchGameDetail(id: Int) {
        Client.getGameDetail(movieId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gameDetail):
                self.game = gameDetail
                self.delegate?.gameLoaded()
            case .failure(let error):
                self.delegate?.gameLoadingError(error: error)
            }
        }
    }
    
    func getGameImageURL() -> URL? {
        URL(string: game?.imageURL ?? "")
    }
    
    func getGameName() -> String {
        game?.name ?? ""

    }
    
    func getGamePlatform() -> String {
        return game?.parentPlatforms.map{$0.platform.name}.joined(separator: ",") ?? ""
    }
    
    func getGameGenre() -> String {
        game?.genres.map{$0.name}.joined(separator: ",") ?? ""
    }
    
    func getGameReleaseDate() -> String {
        game?.releaseDate ?? ""
    }
    
    func getGameTag() -> String {
        let tagCount = game?.tags.count ?? 0
        let numberOfTagsToShow = tagCount >= 5 ? 5 : tagCount
        
        return game?.tags[0..<numberOfTagsToShow].map{$0.name}.joined(separator: ",") ?? ""
    }
    
    func getGameDescription() -> String {
        game?.descriptionRaw ?? ""
    }
    
    func getGameRatingExceptionalCount() -> Int {
        game?.ratings.filter {$0.title == "exceptional"}.first?.count ?? 0
    }
    
    func getGameRatingRecommendedCount() -> Int {
        game?.ratings.filter {$0.title == "recommended"}.first?.count ?? 0
    }
    
    func getGameRatingMehCount() -> Int {
        game?.ratings.filter {$0.title == "meh"}.first?.count ?? 0
    }
    
    func getGameRatingSkipCount() -> Int {
        game?.ratings.filter {$0.title == "skip"}.first?.count ?? 0
    }
    
    func getGameRatingAverage() -> Double {
        game?.rating ?? 0.0
    }
    
    func getGameTime() -> Int {
        game?.playtime ?? 0
    }
    
    func getGameRatingCount() -> Int {
        game?.ratingsCount ?? 0
    }
    
    func isItFavoriteGame() -> Bool {
        guard let gameId = game?.id else { return false }
        return databaseManager.isFavorite(id: gameId)
    }
    
    func addGameToFavoriteList(completion: (Bool) -> ()) {
        if let favoriteGame = databaseManager.addToFavorite(id: game!.id, gameName: game!.name, gameImageURL: game!.imageURL) {
            let favoriteGameDatadict:[String: FavoriteGame] = ["favoriteGame": favoriteGame]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavoriteGameAdded"), object: nil, userInfo: favoriteGameDatadict)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteGameFromFavoriteList(completion: (Bool) -> ()) {
        if databaseManager.deleteFromFavorite(id: game!.id) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavoriteGameDeleted"), object: nil, userInfo: nil)
            completion(true)
        } else {
            completion(false)
        }
    }
    
}
