//
//  RAWGVideoGamesTests.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 9.12.2022.
//

import XCTest

final class GameListViewModelUnitTest: XCTestCase {

    var viewModel: GameListViewModel!
    var fetchExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        viewModel = GameListViewModel()
        viewModel.delegate = self
        fetchExpectation = expectation(description: "fetchGames")
    }
    
    func testGetGameCount() throws {
        //Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        //When
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertEqual(viewModel.getGameCount(), 20)
    }
    

}

extension GameListViewModelUnitTest: GameListViewModelDelegate {
    func gamesLoaded() {
        fetchExpectation.fulfill()
    }
}
