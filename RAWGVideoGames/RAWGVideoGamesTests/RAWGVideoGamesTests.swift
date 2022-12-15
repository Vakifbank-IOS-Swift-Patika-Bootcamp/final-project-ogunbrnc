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
    
    func testGetGameIndexZero() {
        fetchExpectation = expectation(description: "fetchGames")
        
        XCTAssertNil(viewModel.getGame(at: 0))
        
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        let itemAtZero = viewModel.getGame(at: 0)
        XCTAssertEqual(itemAtZero?.id, 3498)
        XCTAssertEqual(itemAtZero?.name, "Grand Theft Auto V")
        XCTAssertEqual(itemAtZero?.playtime, 72)
        
        let parentPlatforms:[Platform]? = [
            Platform(platform: PlatformInfo(id: 1, name: "PC", slug: "pc")),
            Platform(platform: PlatformInfo(id: 2, name: "PlayStation", slug: "playstation")),
            Platform(platform: PlatformInfo(id: 3, name: "Xbox", slug: "xbox"))
        ]
        XCTAssertEqual(itemAtZero?.parentPlatforms, parentPlatforms)
        XCTAssertEqual(itemAtZero?.releaseDate, "2013-09-17")
        XCTAssertEqual(itemAtZero?.imageURL, "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg")
        XCTAssertEqual(itemAtZero?.rating, 4.47)
        
        let ratings: [Rating] = [
            Rating(id: 5, title: "exceptional", count: 3613, percent: 59.1),
            Rating(id: 4, title: "recommended", count: 2003, percent: 32.77),
            Rating(id: 3, title: "meh", count: 385, percent: 6.3),
            Rating(id: 1, title: "skip", count: 112, percent: 1.83),
        ]
        XCTAssertEqual(itemAtZero?.ratings, ratings)
        XCTAssertEqual(itemAtZero?.ratingsCount, 6037)
        
        let genres: [Genre] = [
            Genre(id: 4, name: "Action", slug: "action"),
            Genre(id: 3, name: "Adventure", slug: "adventure")
        ]
        XCTAssertEqual(itemAtZero?.genres, genres)
    }
    
    func testGetSortedGameIndexZero() {
        fetchExpectation = expectation(description: "fetchGames")
        
        XCTAssertNil(viewModel.getGame(at: 0))
        
        viewModel.fetchGamesSorted(by: "Average rating".localized())
        waitForExpectations(timeout: 10)
        
        let itemAtZero = viewModel.getGame(at: 0)
        XCTAssertEqual(itemAtZero?.id, 894438)
        XCTAssertEqual(itemAtZero?.name, "Lil Gator Game")
        XCTAssertEqual(itemAtZero?.playtime, 0)
        
        let parentPlatforms:[Platform]? = [
            Platform(platform: PlatformInfo(id: 1, name: "PC", slug: "pc")),
            Platform(platform: PlatformInfo(id: 7, name: "Nintendo", slug: "nintendo")),
        ]
        
      
        XCTAssertEqual(itemAtZero?.parentPlatforms, parentPlatforms)
        XCTAssertEqual(itemAtZero?.releaseDate, "2022-12-14")
        XCTAssertEqual(itemAtZero?.imageURL, "https://media.rawg.io/media/games/376/37628262db021ad21f81ec8d4b0ded03.jpg")
        XCTAssertEqual(itemAtZero?.rating, 0.0)
        let ratings: [Rating] = []
        XCTAssertEqual(itemAtZero?.ratings, ratings)
        XCTAssertEqual(itemAtZero?.ratingsCount, 0)
        
        let genres: [Genre] = [
            Genre(id: 3, name: "Adventure", slug: "adventure")
        ]
        XCTAssertEqual(itemAtZero?.genres, genres)
    }

    func testGetSortingOptionsIndexZero() {
        let options:[String] = viewModel.getSortingOptions()
        print(options.count)
        XCTAssertEqual(options.count, 6)
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

}

extension GameListViewModelUnitTest: GameListViewModelDelegate {
    func gamesLoaded() {
        fetchExpectation.fulfill()
    }
}
