//
//  GameDetailViewModelUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 16.12.2022.
//

@testable import RAWGVideoGames
import XCTest

final class GameDetailViewModelUnitTest: XCTestCase {

    var viewModel: GameDetailViewModel!
    var fetchExpectation: XCTestExpectation!
    var game: GameDetailModel!
    
    override func setUpWithError() throws {
        game = GameDetailModel(id: 3498,
                               name: "Grand Theft Auto V",
                               descriptionRaw: "Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas. 561 different vehicles (including every transport you can operate) and the amount is rising with every update. \nSimultaneous storytelling from three unique perspectives: \nFollow Michael, ex-criminal living his life of leisure away from the past, Franklin, a kid that seeks the better future, and Trevor, the exact past Michael is trying to run away from. \nGTA Online will provide a lot of additional challenge even for the experienced players, coming fresh from the story mode. Now you will have other players around that can help you just as likely as ruin your mission. Every GTA mechanic up to date can be experienced by players through the unique customizable character, and community content paired with the leveling system tends to keep everyone busy and engaged.",
                               releaseDate: "2013-09-17",
                               imageURL: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
                               parentPlatforms: [
                                Platform(platform: PlatformInfo(id: 1,
                                                                name: "PC",
                                                                slug: "pc"))],
                               genres: [Genre(id: 4, name: "Action", slug: "action")],
                               ratings: [
                                Rating(id: 5, title: "exceptional", count: 3615, percent: 59.11),
                                Rating(id: 4, title: "recommended", count: 2004, percent: 32.77),
                                Rating(id: 3, title: "meh", count: 385, percent: 6.29),
                                Rating(id: 2, title: "skip", count: 112, percent: 1.83)],
                               tags: [Tag(id: 31, name: "Singleplayer", slug: "singleplayer")],
                               playtime: 72,
                               ratingsCount: 6040,
                               rating: 4.47)
        
        viewModel = GameDetailViewModel(game: game)
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
    
    func testGetGameGenre() {
        //Given
        XCTAssertEqual(viewModel.getGameGenre(),"")
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameGenre(), "Action,Adventure")
    }
    
    func testGetGameReleaseDate() {
        //Given
        XCTAssertEqual(viewModel.getGameReleaseDate(),"")
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameReleaseDate(), "2013-09-17")
    }
    
    func testGetGameTag() {
        //Given
        XCTAssertEqual(viewModel.getGameTag(),"")
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameTag(), "Singleplayer,Steam Achievements,Multiplayer,Atmospheric,Full controller support")
    }
    
    func testGetGameDescription() {
        //Given
        XCTAssertEqual(viewModel.getGameDescription(),"")
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)
        
        let description = "Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas. 561 different vehicles (including every transport you can operate) and the amount is rising with every update. \nSimultaneous storytelling from three unique perspectives: \nFollow Michael, ex-criminal living his life of leisure away from the past, Franklin, a kid that seeks the better future, and Trevor, the exact past Michael is trying to run away from. \nGTA Online will provide a lot of additional challenge even for the experienced players, coming fresh from the story mode. Now you will have other players around that can help you just as likely as ruin your mission. Every GTA mechanic up to date can be experienced by players through the unique customizable character, and community content paired with the leveling system tends to keep everyone busy and engaged."

        //Then
        XCTAssertEqual(viewModel.getGameDescription(), description)
    }
    
    func testGetGameRatingExceptionalCount() {
        //Given
        XCTAssertEqual(viewModel.getGameRatingExceptionalCount(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameRatingExceptionalCount(), 3613)
    }
    
    func testGetGameRatingRecommendedCount() {
        //Given
        XCTAssertEqual(viewModel.getGameRatingRecommendedCount(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameRatingRecommendedCount(), 2003)
    }
    func testGetGameRatingMehCount() {
        //Given
        XCTAssertEqual(viewModel.getGameRatingMehCount(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameRatingMehCount(), 385)
    }
    
    func testGetGameRatingSkipCount() {
        //Given
        XCTAssertEqual(viewModel.getGameRatingSkipCount(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameRatingSkipCount(), 112)
    }
    
    func testGetGameRatingAverage() {
        //Given
        XCTAssertEqual(viewModel.getGameRatingAverage(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameRatingAverage(), 4.47)
    }
    
    func testGetGameTime() {
        //Given
        XCTAssertEqual(viewModel.getGameTime(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameTime(), 72)
    }
    
    func testGetGameRatingCount() {
        //Given
        XCTAssertEqual(viewModel.getGameRatingCount(),0)
        
        //When
        viewModel.fetchGameDetail(id: 3498)
        waitForExpectations(timeout: 10)

        //Then
        XCTAssertEqual(viewModel.getGameRatingCount(), 6037)
    }
}

extension GameDetailViewModelUnitTest: GameDetailViewModelDelegate {
    func gameLoadingError(error: Error) {
        fetchExpectation.fulfill()
    }
    
    func gameLoaded() {
        fetchExpectation.fulfill()
    }
}
