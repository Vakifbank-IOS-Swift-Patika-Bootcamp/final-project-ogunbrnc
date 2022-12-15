//
//  GameDetailViewModelUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 16.12.2022.
//

import XCTest

final class GameDetailViewModelUnitTest: XCTestCase {

    var viewModel: GameDetailViewModel!
    var fetchExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        viewModel = GameDetailViewModel()
        viewModel.delegate = self
        fetchExpectation = expectation(description: "fetchGames")
    }
    
    func testGetGameImageURL() {
        //Given
        XCTAssertEqual(viewModel.getGameImageURL(),nil)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)
        
        let imageURL = URL(string: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg")
        //Then
        XCTAssertEqual(viewModel.getGameImageURL(),imageURL)
    }
    
    func testGetGameName() {
        //Given
        XCTAssertEqual(viewModel.getGameName(),"")
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameName(),"Grand Theft Auto V")
    }
    
    func testGetGamePlatform() {
        //Given
        XCTAssertEqual(viewModel.getGamePlatform(),"")
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGamePlatform(), "PC,PlayStation,Xbox")
    }

}

extension GameDetailViewModelUnitTest: GameDetailViewModelDelegate {
    func gameLoaded() {
        fetchExpectation.fulfill()
    }
}
