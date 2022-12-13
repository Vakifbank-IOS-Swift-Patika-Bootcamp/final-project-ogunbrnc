//
//  GameNoteListViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import Foundation

protocol GameNoteListViewModelProtocol {
    var delegate: GameNoteListViewModelDelegate? { get set }
    func fetchGameNotes()
    func getGameNotesCount() -> Int
    func getGameNotesHasReminderCount() -> Int
    func getGameNote(at index: Int) -> GameNote?
    func getGameNoteHasReminder(at index: Int) -> GameNote?
    func getGameNoteId(at index: Int) -> UUID?
    func getGameNoteHasReminderId(at index: Int) -> UUID? 
    func add(note: GameNote)
    func update(note: GameNote)
    func delete(id: UUID)
}

protocol GameNoteListViewModelDelegate: AnyObject {
    func gameNotesLoaded()
}

final class GameNoteListViewModel: GameNoteListViewModelProtocol {
    
    weak var delegate: GameNoteListViewModelDelegate?
    
    private var gameNotes: [GameNote]?
    private var gameNotesHasReminder: [GameNote]?
    
    
    func fetchGameNotes() {
        let gameNotesReminders = CoreDataManager.shared.getNotes()
        gameNotes = gameNotesReminders.filter { !$0.noteHasReminder}
        gameNotesHasReminder = gameNotesReminders.filter { $0.noteHasReminder }
        delegate?.gameNotesLoaded()
    }
    
    func getGameNotesCount() -> Int {
        gameNotes?.count ?? 0
    }
    
    func getGameNotesHasReminderCount() -> Int {
        gameNotesHasReminder?.count ?? 0
    }
    
    func getGameNote(at index: Int) -> GameNote? {
        gameNotes?[index]
    }
    
    func getGameNoteHasReminder(at index: Int) -> GameNote? {
        gameNotesHasReminder?[index]
    }
    
    func getGameNoteId(at index: Int) -> UUID? {
        gameNotes![index].id
    }
    
    func getGameNoteHasReminderId(at index: Int) -> UUID? {
        gameNotesHasReminder![index].id
    }
    
    func add(note: GameNote) {
        gameNotes?.append(note)
        delegate?.gameNotesLoaded()
    }
    
    func update(note: GameNote) {
        if let row = gameNotes?.firstIndex(where: {$0.id == note.id}) {
            gameNotes?[row] = note
            delegate?.gameNotesLoaded()
        }
    }
    
    func delete(id: UUID){
        let success = CoreDataManager.shared.deleteNote(id: id)
        if success {
            //since game id string is equal to empty string after deletion from coredata, we remove the one whose id is equal to empty string.
            if let index = gameNotes?.enumerated().filter({$0.element.id == nil}).map({$0.offset}).first {
                gameNotes?.remove(at: index)
                delegate?.gameNotesLoaded()
            }
        }
    }
}

