//
//  GameNoteAddingEditingViewModelUnitTest.swift
//  RAWGVideoGamesTests
//
//  Created by Ogün Birinci on 18.12.2022.
//

@testable import RAWGVideoGames
import XCTest
import CoreData

final class GameNoteAddingEditingViewModelUnitTest: XCTestCase {

    var databaseManager: DatabaseManager!
    var viewModel: GameNoteAddingEditingViewModel!
    var viewModelUndefinedNote: GameNoteAddingEditingViewModel!
    var fetchExpectation: XCTestExpectation!
    var gameNoteWithReminder: NSManagedObject!
    var gameNote: NSManagedObject!

    
    override func setUpWithError() throws {
        
        databaseManager = CoreDataManager.shared
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GameNote", in: managedContext)!
        
        gameNoteWithReminder = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNoteWithReminder.setValue("Grand Theft Auto V", forKeyPath: "gameName")
        gameNoteWithReminder.setValue("Note Reminder content", forKeyPath: "noteContent")
        gameNoteWithReminder.setValue(Date.now, forKeyPath: "noteDate")
        gameNoteWithReminder.setValue(UUID(), forKey: "id")
        gameNoteWithReminder.setValue(Date.now.addingTimeInterval(5 * 60), forKey: "noteScheduledReminderDate")
        gameNoteWithReminder.setValue(true, forKey: "noteHasReminder")
        
        
        gameNote = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNote.setValue("Grand Theft Auto 4", forKeyPath: "gameName")
        gameNote.setValue("Note content", forKeyPath: "noteContent")
        gameNote.setValue(Date.now, forKeyPath: "noteDate")
        gameNote.setValue(UUID(), forKey: "id")
        gameNote.setValue(nil, forKey: "noteScheduledReminderDate")
        gameNote.setValue(false, forKey: "noteHasReminder")

        
        if let noteWithReminder = gameNoteWithReminder as? GameNote,
           let note = gameNote as? GameNote {
            viewModel = GameNoteAddingEditingViewModel(gameNote: note)
            viewModelUndefinedNote = GameNoteAddingEditingViewModel()
            viewModel.delegate = self
        }
    }
    
    func testNoteContent() {
        XCTAssertEqual(viewModel.getNoteContent(),"Note content")
    }
    
    func testAddNewNote() {
        guard let note =  viewModelUndefinedNote.saveNote(gameName: "Grand Theft Auto 4",
                                                          noteContent: "Note content"),
              let noteId = note.id  else { return }
        
        XCTAssertEqual(note.noteContent, "Note content")
        
        // delete after test
        if databaseManager.deleteNote(id: noteId) { print ("deleted")}
        
    }
    
    
}

extension GameNoteAddingEditingViewModelUnitTest: GameNoteAddingEditingViewModelDelegate {
    func didNoteLoaded(gameNote: RAWGVideoGames.GameNote?, pageViewMode: RAWGVideoGames.PageViewMode) {
        fetchExpectation.fulfill()
    }
    
    func didAddReminder(gameNote: RAWGVideoGames.GameNote) {
        fetchExpectation.fulfill()
    }
    
    func didUpdateReminder(gameNote: RAWGVideoGames.GameNote) {
        fetchExpectation.fulfill()
    }
    
    func didAddNote(gameNote: RAWGVideoGames.GameNote) {
        fetchExpectation.fulfill()
    }
    
    func didUpdateNote(gameNote: RAWGVideoGames.GameNote) {
        fetchExpectation.fulfill()
    }
    
    func didAuthErrorOccur(error: String) {
        fetchExpectation.fulfill()
    }
}
