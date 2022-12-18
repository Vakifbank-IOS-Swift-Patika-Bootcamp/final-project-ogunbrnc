//
//  LocalNotificationManagerUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 18.12.2022.
//
@testable import RAWGVideoGames
import XCTest

final class LocalNotificationManagerUnitTest: XCTestCase {

    var localNotificationManager: NotificationProtocol!
    var fetchExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        localNotificationManager = LocalNotificationManager()
    }
    
    
    func testScheduleNotification() {
        localNotificationManager.scheduleNotification(title: "Test Notification", message: "Test Notification Content", id: UUID(), date: Date.now.addingTimeInterval(5 * 60)) { result in
            
            XCTAssertEqual(result, .success)
        }
    }
    
    func testUpdateScheduledNotification() {
        localNotificationManager.updateScheduledNotification(title: "Test Notification Updated", message: "Test Notification Content Updated", id: UUID(), date: Date.now.addingTimeInterval(10*60)) { result in
            
            XCTAssertEqual(result, .success)
        }
    }
    
    func testDeleteScheduledNotification() {
        let id = UUID()
        localNotificationManager.scheduleNotification(title: "Test Notification", message: "Test Notification Content", id: id, date: Date.now.addingTimeInterval(5 * 60)) { result in
            
            XCTAssertEqual(result, .success)
        }
        
        localNotificationManager.deleteScheduledNotification(id: id) { result in
            XCTAssertEqual(result, .success)
        }
    }
    

}
