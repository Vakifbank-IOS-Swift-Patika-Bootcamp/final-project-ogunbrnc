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
    var viewModelNilNote: GameNoteAddingEditingViewModel!
    var fetchExpectation: XCTestExpectation!
    var gameNote: NSManagedObject!

    
    override func setUpWithError() throws {
        
        databaseManager = CoreDataManager.shared
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GameNote", in: managedContext)!
        
        gameNote = NSManagedObject(entity: entity, insertInto: managedContext)
        gameNote.setValue("Grand Theft Auto 4", forKeyPath: "gameName")
        gameNote.setValue("Note content", forKeyPath: "noteContent")
        gameNote.setValue(Date.now, forKeyPath: "noteDate")
        gameNote.setValue(UUID(), forKey: "id")
        gameNote.setValue(nil, forKey: "noteScheduledReminderDate")
        gameNote.setValue(false, forKey: "noteHasReminder")

        guard let note = gameNote as? GameNote else { return }
        viewModel = GameNoteAddingEditingViewModel(gameNote: note)
        viewModelNilNote = GameNoteAddingEditingViewModel()
        viewModel.delegate = self
        viewModelNilNote.delegate = self
    }
    
    func testAddNewNote() {
        fetchExpectation = expectation(description: "fetchGame")

        guard let note =  viewModelNilNote.saveNote(gameName: "Grand Theft Auto 3",
                                                          noteContent: "Note content") else { return }

        
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(note.noteContent, "Note content")
        
    }
    
    func testUpdateNote() {
        guard let note =  gameNote as? GameNote,
              let gameName = note.gameName else { return }
                
        guard let noteUpdated = viewModel.saveNote(gameName: gameName,
                                                           noteContent: "Note content updated") else { return }

        XCTAssertEqual(noteUpdated.noteContent, "Note content updated")
        
    }
    
    func testUpdateWithSameNoteContent() {
        guard let note =  gameNote as? GameNote,
              let gameName = note.gameName,
              let noteContent = note.noteContent else { return }
                
        // update with same content.
        guard let noteUpdated = viewModel.saveNote(gameName: gameName,
                                                   noteContent: noteContent) else { return }

        XCTAssertNil(noteUpdated)  
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
