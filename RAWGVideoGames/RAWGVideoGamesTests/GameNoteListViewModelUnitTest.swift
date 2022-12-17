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
    var notesWithReminder: [GameNote]?



    
    override func setUpWithError() throws {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GameNote", in: managedContext)!
        
        gameNoteWithReminder = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNoteWithReminder.setValue("Grand Theft Auto V", forKeyPath: "gameName")
        gameNoteWithReminder.setValue("Note content", forKeyPath: "noteContent")
        gameNoteWithReminder.setValue(Date.now, forKeyPath: "noteDate")
        gameNoteWithReminder.setValue(UUID(uuidString: "1"), forKey: "id")
        gameNoteWithReminder.setValue(Date.now.addingTimeInterval(5 * 60), forKey: "noteScheduledReminderDate")
        gameNoteWithReminder.setValue(true, forKey: "noteHasReminder")
        
        
        gameNote = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNote.setValue("Grand Theft Auto 4", forKeyPath: "gameName")
        gameNote.setValue("Note content", forKeyPath: "noteContent")
        gameNote.setValue(Date.now, forKeyPath: "noteDate")
        gameNote.setValue(UUID(uuidString: "2"), forKey: "id")
        gameNote.setValue(nil, forKey: "noteScheduledReminderDate")
        gameNote.setValue(false, forKey: "noteHasReminder")

        
        if let noteWithReminder = gameNoteWithReminder as? GameNote,
           let note = gameNote as? GameNote {
            notes = [note]
            notesWithReminder = [noteWithReminder]
            viewModel = GameNoteListViewModel(gameNotes: notes,gameNotesHasReminder: notesWithReminder)
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
    
    func testGetGameNotesHasReminderCount() {
        XCTAssertEqual(viewModel.getGameNotesHasReminderCount(), notesWithReminder?.count)
    }
    
    func testGetGameNote() {
        XCTAssertEqual(viewModel.getGameNote(at: 0), notes?[0])
    }
    
    func testGetGameNoteHasReminder() {
        XCTAssertEqual(viewModel.getGameNoteHasReminder(at: 0), notesWithReminder?[0])
    }
    
    func testGetGameNoteId() {
        XCTAssertEqual(viewModel.getGameNoteId(at: 0), notes?[0].id)
    }
    
    func testGetGameNoteHasReminderId() {
        XCTAssertEqual(viewModel.getGameNoteHasReminderId(at: 0), notesWithReminder?[0].id)
    }
    
}

extension GameNoteListViewModelUnitTest: GameNoteListViewModelDelegate {
    func gameNotesLoaded() {
        fetchExpectation.fulfill()
    }
    
}
