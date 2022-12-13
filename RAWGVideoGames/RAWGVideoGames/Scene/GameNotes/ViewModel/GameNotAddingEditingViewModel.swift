//
//  GameNotAddingEditingViewModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import Foundation

protocol GameNoteAddingEditingViewModelProtocol {
    var delegate: GameNoteAddingEditingViewModelDelegate? { get set }
    func getNote(noteId: UUID?)
    func saveNote(gameName: String, noteContent: String)
    func saveReminder(gameName: String, reminderContent: String, reminderDate: Date)
}

protocol GameNoteAddingEditingViewModelDelegate: AnyObject {
    func didNoteLoaded(gameNote: GameNote?)
    func didAddNote(gameNote: GameNote)
    func didUpdateNote(gameNote: GameNote)
}

final class GameNoteAddingEditingViewModel: GameNoteAddingEditingViewModelProtocol {
    private var notificationManager: NotificationProtocol
    weak var delegate: GameNoteAddingEditingViewModelDelegate?
    private var gameNote: GameNote?
    
    init(notificationManager: NotificationProtocol = LocalNotificationManager.shared, gameNote: GameNote? = nil) {
        self.notificationManager = notificationManager
        self.gameNote = gameNote
    }
    
    func getNote(noteId: UUID?) {
        gameNote = CoreDataManager.shared.getNote(noteId: noteId ?? UUID())
        delegate?.didNoteLoaded(gameNote: gameNote)
    }
    
    func saveNote(gameName: String, noteContent: String) {
        
        //adding new note
        if gameNote == nil {
            if let gameNote =  CoreDataManager.shared.addNote(gameName: gameName, noteContent: noteContent, noteHasReminder: false) {
                delegate?.didAddNote(gameNote: gameNote)
            }
        }
        //updating note
        else {
            guard let gameNoteId = gameNote?.id else { return }
            
            if gameNote?.noteContent == noteContent {
                return
            }
            
            if let updatedGameNote = CoreDataManager.shared.updateNote(noteContent: noteContent, gameNoteId: gameNoteId) {
                delegate?.didUpdateNote(gameNote: updatedGameNote)
            }
        }
    }
    
    func saveReminder(gameName: String, reminderContent: String, reminderDate: Date) {
        if gameNote == nil {
            guard let gameNote = CoreDataManager.shared.addNote(gameName: gameName, noteContent: reminderContent, noteHasReminder: true),
                  let gameNoteId = gameNote.id else {
                return
            }
            notificationManager.scheduleNotification(title: gameName, message: reminderContent, id: gameNoteId, date: reminderDate, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.didAddNote(gameNote: gameNote)
                case .failure(let error):
                    print(error)
                }
            })
        }
        else {
            guard let gameNoteId = gameNote?.id else { return }
            guard let gameNote = CoreDataManager.shared.updateNote(noteContent: reminderContent, gameNoteId: gameNoteId) else {
                return
            }
            
            notificationManager.updateScheduledNotification(title: gameName, message: reminderContent, id: gameNoteId, date: reminderDate, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.didUpdateNote(gameNote: gameNote)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}

