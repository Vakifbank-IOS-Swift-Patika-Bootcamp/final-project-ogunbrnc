//
//  ExtensionsUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 18.12.2022.
//
@testable import RAWGVideoGames
import XCTest

final class ExtensionsUnitTest: XCTestCase {
    
    var date: Date!
    
    override func setUpWithError() throws {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 12
        dateComponents.day = 18
        dateComponents.hour = 15
        dateComponents.minute = 06
        
        let userCalendar = Calendar(identifier: .gregorian)
        date = userCalendar.date(from: dateComponents)
        
    }
    
    func testToFormattedString() {
        XCTAssertEqual(date.toFormattedString(), "15:06 Paz, 18 Ara 2022")
    }


}
