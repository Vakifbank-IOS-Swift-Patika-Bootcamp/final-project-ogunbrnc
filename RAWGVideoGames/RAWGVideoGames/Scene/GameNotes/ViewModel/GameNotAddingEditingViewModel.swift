//
//  GameNotAddingEditingViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import Foundation

enum PageViewMode {
    case add
    case edit
}

protocol GameNoteAddingEditingViewModelProtocol {
    var delegate: GameNoteAddingEditingViewModelDelegate? { get set }
    func getNote(noteId: UUID?)
    func getNoteContent() -> String
    func saveNote(gameName: String, noteContent: String)
    func saveReminder(gameName: String, reminderContent: String, reminderDate: Date)
}

protocol GameNoteAddingEditingViewModelDelegate: AnyObject {
    func didNoteLoaded(gameNote: GameNote?,pageViewMode: PageViewMode)
    func didAddReminder(gameNote: GameNote)
    func didUpdateReminder(gameNote: GameNote)
    func didAddNote(gameNote: GameNote)
    func didUpdateNote(gameNote: GameNote)
    func didAuthErrorOccur(error: String)
}

final class GameNoteAddingEditingViewModel: GameNoteAddingEditingViewModelProtocol {
    weak var delegate: GameNoteAddingEditingViewModelDelegate?

    private var notificationManager: NotificationProtocol
    private var databaseManager: DatabaseManager
    private var gameNote: GameNote?
    
    init(databaseManager: DatabaseManager = CoreDataManager.shared,
         notificationManager: NotificationProtocol = LocalNotificationManager.shared) {
        self.databaseManager = databaseManager
        self.notificationManager = notificationManager
    }
    
    func getNote(noteId: UUID?) {
        gameNote = databaseManager.getNote(noteId: noteId ?? UUID())
        let pageViewMode: PageViewMode = gameNote == nil ? .add : .edit
        delegate?.didNoteLoaded(gameNote: gameNote,pageViewMode: pageViewMode)
    }
    
    func getNoteContent() -> String {
        gameNote?.noteContent ?? ""
    }
    
    func saveNote(gameName: String, noteContent: String) {
        
        //adding new note
        if gameNote == nil {
            if let gameNote =  databaseManager.addNote(gameName: gameName, noteContent: noteContent, noteHasReminder: false) {
                delegate?.didAddNote(gameNote: gameNote)
            }
        }
        //updating note
        else {
            guard let gameNoteId = gameNote?.id else { return }
            if gameNote?.noteContent == noteContent {
                return
            }
            
            if let updatedGameNote = databaseManager.updateNote(noteContent: noteContent, gameNoteId: gameNoteId) {
                delegate?.didUpdateNote(gameNote: updatedGameNote)
            }
        }
    }
    
    func saveReminder(gameName: String, reminderContent: String, reminderDate: Date) {
        if gameNote == nil {
            guard let gameNote = databaseManager.addNote(gameName: gameName, noteContent: reminderContent, noteHasReminder: true, noteScheduledReminderDate: reminderDate),
                  let gameNoteId = gameNote.id else {
                return
            }
            notificationManager.scheduleNotification(title: gameName, message: reminderContent, id: gameNoteId, date: reminderDate, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.didAddReminder(gameNote: gameNote)
                case .failure(let error):
                    self.delegate?.didAuthErrorOccur(error: error.localizedDescription)
                }
            })
        }
        else {
            
            guard let gameNoteId = gameNote?.id else { return }
            guard let gameNote = databaseManager.updateNote(noteContent: reminderContent,noteScheduledReminderDate: reminderDate, gameNoteId: gameNoteId) else {
                return
            }
            notificationManager.updateScheduledNotification(title: gameName, message: reminderContent, id: gameNoteId, date: reminderDate, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.didUpdateReminder(gameNote: gameNote)
                    print("update edildi")
                case .failure(let error):
                    self.delegate?.didAuthErrorOccur(error: error.localizedDescription)
                }
            })
        }
    }
}

