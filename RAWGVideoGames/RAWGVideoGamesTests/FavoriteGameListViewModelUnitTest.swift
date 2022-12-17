//
//  FavoriteGameListViewModelUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 18.12.2022.
//

@testable import RAWGVideoGames
import XCTest
import CoreData

final class FavoriteGameListViewModelUnitTest: XCTestCase {
    
    var viewModel: FavoriteGameListViewModel!
    var fetchExpectation: XCTestExpectation!
    var games: [FavoriteGame]?
    var game: NSManagedObject!
    var deletedGame: NSManagedObject!
    
    override func setUpWithError() throws {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
        
        game = NSManagedObject(entity: entity, insertInto: managedContext)
        game.setValue(3498, forKeyPath: "gameId")
        game.setValue("https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg", forKey: "imageURL")
        game.setValue("Grand Theft Auto V", forKey: "name")
        
        deletedGame = NSManagedObject(entity: entity, insertInto: managedContext)
        deletedGame.setValue(0, forKeyPath: "gameId")
        deletedGame.setValue("",forKey: "imageURL")
        deletedGame.setValue("", forKey: "name")
        
        guard let favoriteGame = game as? FavoriteGame,
              let favoriteGameDeleted = deletedGame as? FavoriteGame else { return }
        
        games = [favoriteGame,favoriteGameDeleted]
        viewModel = FavoriteGameListViewModel(games: games)
        viewModel.delegate = self
    }
    
    func testNewGameAddedToFavorites() {
        fetchExpectation = expectation(description: "fetchGame")

        guard let favoriteGame = game as? FavoriteGame else { return }

        viewModel.newGameAddedToFavorites(game: favoriteGame)
        
        waitForExpectations(timeout: 10)

        let lastIndex = viewModel.getGameCount() - 1
        
        XCTAssertEqual(viewModel.getGameId(at: lastIndex), Int(favoriteGame.gameId))
        
        // remove last favorite item
        viewModel.deleteGameFromFavoriteList(index: lastIndex) { result in }
        
    }
    
    func testGameDeletedFromFavorites() {
        fetchExpectation = expectation(description: "fetchGame")

        let gameCountBeforeDelete = viewModel.getGameCount()

        viewModel.gameDeletedFromFavorites()
        
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(viewModel.getGameCount(),gameCountBeforeDelete - 1)
    }
    
    func testDeleteGameFromFavoriteList() {
        guard let favoriteGame = game as? FavoriteGame else { return }

        XCTAssertEqual(viewModel.getGameId(at: 0), Int(favoriteGame.gameId))
        
        let gameCountBeforeDelete = viewModel.getGameCount()

        viewModel.deleteGameFromFavoriteList(index: 0) { result in
            if result {
                XCTAssertEqual(viewModel.getGameCount(), gameCountBeforeDelete - 1)
            }
        }
    }
    
    func testGetGameCount() {
        XCTAssertEqual(viewModel.getGameCount(), games?.count)
    }
    
    func testGetGame() {
        XCTAssertEqual(Int(viewModel.getGame(at: 0)?.gameId ?? 0), Int(games?[0].gameId ?? 0))
    }
    
    func testGetGameId() {
        XCTAssertEqual(viewModel.getGameId(at: 0), Int(games?[0].gameId ?? 0))
    }
    
    
}

extension FavoriteGameListViewModelUnitTest: FavoriteGameListViewModelDelegate {
    func gamesLoaded() {
        fetchExpectation.fulfill()
    }
}
