//
//  GameNoteListViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import Foundation

protocol GameNoteListViewModelProtocol {
    var delegate: GameNoteListViewModelDelegate? { get set }
    func isEditable(note: GameNote) -> Bool
    func fetchGameNotes()
    func getGameNotesCount() -> Int
    func getGameNotesHasReminderCount() -> Int
    func getGameNote(at index: Int) -> GameNote?
    func getGameNoteHasReminder(at index: Int) -> GameNote?
    func getGameNoteId(at index: Int) -> UUID?
    func getGameNoteHasReminderId(at index: Int) -> UUID? 
    func add(note: GameNote)
    func add(reminder: GameNote)
    func update(note: GameNote) -> String
    func update(reminder: GameNote) -> String
    func delete(id: UUID)
    func deleteReminder(id: UUID)

}

protocol GameNoteListViewModelDelegate: AnyObject {
    func gameNotesLoaded()
}

final class GameNoteListViewModel: GameNoteListViewModelProtocol {
   
    
    private var notificationManager: NotificationProtocol
    weak var delegate: GameNoteListViewModelDelegate?
    private var databaseManager: DatabaseManager

    private var gameNotes: [GameNote]?
    private var gameNotesHasReminder: [GameNote]?
    
    init(databaseManager: DatabaseManager = CoreDataManager.shared,
         notificationManager: NotificationProtocol = LocalNotificationManager.shared,
         gameNotes: [GameNote]? = nil,
         gameNotesHasReminder: [GameNote]? = nil
    ) {
        self.databaseManager = databaseManager
        self.notificationManager = notificationManager
        self.gameNotes = gameNotes
        self.gameNotesHasReminder = gameNotesHasReminder
    }
    
    func isEditable(note: GameNote) -> Bool {
        guard let noteScheduledReminderDate = note.noteScheduledReminderDate else { return false }
        let currentTime = Date.now
        return noteScheduledReminderDate > currentTime
    }
    
    func fetchGameNotes() {
        let gameNotesReminders = databaseManager.getNotes()
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
    
    func update(note: GameNote) -> String{
        if let row = gameNotes?.firstIndex(where: {$0.id == note.id}) {
            gameNotes?[row] = note
            delegate?.gameNotesLoaded()
        }
        return note.noteContent ?? ""
    }
    
    func add(reminder: GameNote) {
        gameNotesHasReminder?.append(reminder)
        delegate?.gameNotesLoaded()
    }
    
    func update(reminder: GameNote) -> String {
        if let row = gameNotesHasReminder?.firstIndex(where: {$0.id == reminder.id}) {
            gameNotesHasReminder?[row] = reminder
            delegate?.gameNotesLoaded()
        }
        return reminder.noteContent ?? ""
    }
    
    func delete(id: UUID){
        let success = databaseManager.deleteNote(id: id)
        if success {
            //since game id string is equal to empty string after deletion from coredata, we remove the one whose id is equal to empty string.
            if let index = gameNotes?.enumerated().filter({$0.element.id == nil}).map({$0.offset}).first {
                gameNotes?.remove(at: index)
                delegate?.gameNotesLoaded()
            }
        }
    }
    func deleteReminder(id: UUID) {
        let success = databaseManager.deleteNote(id: id)
        if success {
            notificationManager.deleteScheduledNotification(id: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    if let index = self.gameNotesHasReminder?.enumerated().filter({$0.element.id == nil}).map({$0.offset}).first {
                        self.gameNotesHasReminder?.remove(at: index)
                        self.delegate?.gameNotesLoaded()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}

