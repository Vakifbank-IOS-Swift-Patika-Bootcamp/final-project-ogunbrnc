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
    
    override func setUpWithError() throws {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        
        game.setValue(3498, forKeyPath: "gameId")
        game.setValue("https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg", forKey: "imageURL")
        game.setValue("Grand Theft Auto V", forKey: "name")
        guard let gameEntity = game as? FavoriteGame else { return }
        
        games = [FavoriteGame(entity: entity, insertInto: managedContext)]
        viewModel = FavoriteGameListViewModel(games: [gameEntity])
        viewModel.delegate = self
    }
    
    func testFetchGamesIndexZero() {
        fetchExpectation = expectation(description: "fetchGame")
                
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(viewModel.getGameId(at: 0),3498)

    }
}

extension FavoriteGameListViewModelUnitTest: FavoriteGameListViewModelDelegate {
    func gamesLoaded() {
        fetchExpectation.fulfill()
    }
}
