//
//  GameNoteListViewModelUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 18.12.2022.
//
@testable import RAWGVideoGames
import XCTest
import CoreData

final class GameNoteListViewModelUnitTest: XCTestCase {

    var viewModel: GameNoteListViewModel!
    var fetchExpectation: XCTestExpectation!
    var gameNoteWithReminder: NSManagedObject!
    var gameNote: NSManagedObject!
    var notes: [GameNote]?


    
    override func setUpWithError() throws {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GameNote", in: managedContext)!
        
        gameNoteWithReminder = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNoteWithReminder.setValue("Grand Theft Auto V", forKeyPath: "gameName")
        gameNoteWithReminder.setValue(UUID(), forKeyPath: "id")
        gameNoteWithReminder.setValue("Note content", forKeyPath: "noteContent")
        gameNoteWithReminder.setValue(Date.now, forKeyPath: "noteDate")
        gameNoteWithReminder.setValue(UUID(), forKey: "id")
        gameNoteWithReminder.setValue(Date.now.addingTimeInterval(5 * 60), forKey: "noteScheduledReminderDate")
        
        gameNote = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNote.setValue("Grand Theft Auto 4", forKeyPath: "gameName")
        gameNote.setValue(UUID(), forKeyPath: "id")
        gameNote.setValue("Note content", forKeyPath: "noteContent")
        gameNote.setValue(Date.now, forKeyPath: "noteDate")
        gameNote.setValue(UUID(), forKey: "id")
        gameNote.setValue(nil, forKey: "noteScheduledReminderDate")
        
        
        if let noteWithReminder = gameNoteWithReminder as? GameNote,
           let note = gameNote as? GameNote {
            notes = [noteWithReminder,note]
            viewModel = GameNoteListViewModel(gameNotes: notes)
            viewModel.delegate = self
        }
    }
    
    func testIsEditable() {
        guard let noteWithReminder = gameNoteWithReminder as? GameNote else { return }
        XCTAssertTrue(viewModel.isEditable(note: noteWithReminder))
    }
    
    func testIsEditableWithoutReminder() {
        guard let note = gameNote as? GameNote else { return }
        XCTAssertFalse(viewModel.isEditable(note: note))
    }
    
    func testGetGameNotesCount() {
        XCTAssertEqual(viewModel.getGameNotesCount(), notes?.count)
    }
    
    
}

extension GameNoteListViewModelUnitTest: GameNoteListViewModelDelegate {
    func gameNotesLoaded() {
        fetchExpectation.fulfill()
    }
    
}
