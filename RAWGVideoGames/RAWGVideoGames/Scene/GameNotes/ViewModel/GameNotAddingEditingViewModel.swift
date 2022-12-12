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
    
    weak var delegate: GameNoteAddingEditingViewModelDelegate?
    private var gameNote: GameNote?
    private var localNotificationManager: LocalNotificationManagerProtocol?
    
    func getNote(noteId: UUID?) {
        gameNote = CoreDataManager.shared.getNote(noteId: noteId ?? UUID())
        delegate?.didNoteLoaded(gameNote: gameNote)
    }
    
    func saveNote(gameName: String, noteContent: String) {
        //adding new note
        if gameNote == nil {
            if let gameNote =  CoreDataManager.shared.addNote(gameName: gameName, noteContent: noteContent) {
                delegate?.didAddNote(gameNote: gameNote)
            }
        }
        //updating note
        else {
            if gameNote?.noteContent == noteContent {
                return
            }
            
            if let updatedGameNote = CoreDataManager.shared.updateNote(noteContent: noteContent, gameNote: gameNote!) {
                delegate?.didUpdateNote(gameNote: updatedGameNote)
            }
        }
    }
    
    func saveReminder(gameName: String, reminderContent: String, reminderDate: Date) {
        localNotificationManager?.scheduleLocalNotification(title: gameName, message: reminderContent, date: reminderDate, completion: { result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        })
    }
    
}

