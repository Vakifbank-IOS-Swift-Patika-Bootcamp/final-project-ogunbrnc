//
//  GameDetailViewModelFetchUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 17.12.2022.
//

import Foundation

@testable import RAWGVideoGames
import XCTest

final class GameDetailViewModelFetchUnitTest: XCTestCase {
    
    var viewModel: GameDetailViewModel!
    var fetchExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        viewModel = GameDetailViewModel()
        viewModel.delegate = self
    }
    
    func testFetchGameDetail() {
        fetchExpectation = expectation(description: "fetchGame")
                
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(viewModel.getGameName(), "Grand Theft Auto V")

    }
    
    func testFetchGameDetailInvalidID() {
        fetchExpectation = expectation(description: "fetchGame")

        viewModel.fetchGameDetail(id: 12345678)
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(viewModel.getGameName(), "")

    }
    
    
}

extension GameDetailViewModelFetchUnitTest: GameDetailViewModelDelegate {
    func gameLoadingError(error: Error) {
        fetchExpectation.fulfill()
    }
    
    func gameLoaded() {
        fetchExpectation.fulfill()
    }
}

