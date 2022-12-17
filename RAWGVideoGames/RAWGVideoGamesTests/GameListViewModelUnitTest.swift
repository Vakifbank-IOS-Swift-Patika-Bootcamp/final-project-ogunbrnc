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
    }
    
    func testFetchGameIndexZero() {
        fetchExpectation = expectation(description: "fetchGames")
        
        XCTAssertNil(viewModel.getGame(at: 0))
        
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        let itemAtZero = viewModel.getGame(at: 0)
        XCTAssertEqual(itemAtZero?.id, 3498)
    }
    
    func testFetchSearchedGamesIndexZero() {
        fetchExpectation = expectation(description: "fetchGames")
        
        XCTAssertNil(viewModel.getGame(at: 0))
        
        viewModel.fetchSearchedGames(with: "Grand Theft Auto Vice")
        waitForExpectations(timeout: 10)
        
        let itemAtZero = viewModel.getGame(at: 0)
        XCTAssertEqual(itemAtZero?.id, 430)
    }

    func testGetSortingOptions() {
        let sortingOptions = ["Relevance".localized(),
                              "Date added".localized(),
                              "Name".localized(),
                              "Release date".localized(),
                              "Popularity".localized(),
                              "Average rating".localized()].sorted()
        
        let options:[String] = viewModel.getSortingOptions().sorted()
         
     
        XCTAssertEqual(options,sortingOptions)
    }
    
    func testGetGameCount() throws {
        fetchExpectation = expectation(description: "fetchGames")
        //Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        //When
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertEqual(viewModel.getGameCount(), 20)
    }
    
    func testGetGameIdIndexZero() {
        fetchExpectation = expectation(description: "fetchGames")
        //Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        //When
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertEqual(viewModel.getGameId(at: 0), 3498)
        
    }

}

extension GameListViewModelUnitTest: GameListViewModelDelegate {
    func gamesLoadingError(error: Error) {
        fetchExpectation.fulfill()
    }
    
    func gamesLoaded() {
        fetchExpectation.fulfill()
    }
    
}
