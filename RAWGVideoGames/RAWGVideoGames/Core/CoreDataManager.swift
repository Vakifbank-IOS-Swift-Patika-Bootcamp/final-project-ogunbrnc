//
//  CoreDataManager.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit
import CoreData

protocol DatabaseManager {
    func isFavorite(id gameId: Int) -> Bool
    func getFavoriteGames() -> [FavoriteGame]
    func addToFavorite(id: Int, gameName: String, gameImageURL: String) -> FavoriteGame?
    func deleteFromFavorite(id gameId: Int) -> Bool
    func getNote(noteId: UUID) -> GameNote?
    func getNotes() -> [GameNote]
    func addNote(gameName: String, noteContent: String, noteHasReminder: Bool, noteScheduledReminderDate: Date?) -> GameNote?
    func updateNote(noteContent: String,noteScheduledReminderDate: Date? ,gameNoteId: UUID) -> GameNote?
    func deleteNote(id: UUID) -> Bool
}

extension DatabaseManager {
    func updateNote(noteContent: String,noteScheduledReminderDate: Date? = nil ,gameNoteId: UUID) -> GameNote? {
        updateNote(noteContent: noteContent, noteScheduledReminderDate: noteScheduledReminderDate, gameNoteId: gameNoteId)
    }
    func addNote(gameName: String, noteContent: String, noteHasReminder: Bool, noteScheduledReminderDate: Date? = nil ) -> GameNote? {
        addNote(gameName: gameName, noteContent: noteContent, noteHasReminder: noteHasReminder, noteScheduledReminderDate: noteScheduledReminderDate)
    }
}

final class CoreDataManager:DatabaseManager {
    static let shared = CoreDataManager(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    private let managedContext: NSManagedObjectContext
        
    private init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func isFavorite(id gameId: Int) -> Bool {
        let fetchNote: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "gameId = %@", String(gameId))

        let results = try? managedContext.fetch(fetchNote)

        return results?.count != 0
        
    }
    
    func getFavoriteGames() -> [FavoriteGame] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
        do {
            let games = try managedContext.fetch(fetchRequest)
            return games as! [FavoriteGame]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    
    func addToFavorite(id: Int, gameName: String, gameImageURL: String) -> FavoriteGame? {
        let fetchGame: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchGame.predicate = NSPredicate(format: "gameId = %@", String(id))

        if let _ = try? managedContext.fetch(fetchGame).first {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        game.setValue(id, forKeyPath: "gameId")
        game.setValue(gameImageURL, forKey: "imageURL")
        game.setValue(gameName, forKey: "name")
        
        do {
            try managedContext.save()
            return game as? FavoriteGame
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteFromFavorite(id gameId: Int) -> Bool {
        let fetchGame: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchGame.predicate = NSPredicate(format: "gameId = %@", String(gameId))

        if let game = try? managedContext.fetch(fetchGame).first {
            managedContext.delete(game)
            do {
                try managedContext.save()
                return true
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return false
            }
        }
        return false
    }
    
    
    func getNote(noteId: UUID) -> GameNote? {
        let fetchNote: NSFetchRequest<GameNote> = GameNote.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "id = %@", noteId.uuidString)

        let results = try? managedContext.fetch(fetchNote)
        if let note = results?.first {
            return note
        }

        return nil
    }
    
    func getNotes() -> [GameNote] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameNote")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [GameNote]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    
    func addNote(gameName: String, noteContent: String, noteHasReminder: Bool, noteScheduledReminderDate: Date? = nil) -> GameNote? {
        let entity = NSEntityDescription.entity(forEntityName: "GameNote", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let noteDate = Date.now
        let noteId = UUID()
        
        note.setValue(gameName, forKeyPath: "gameName")
        note.setValue(noteId, forKeyPath: "id")
        note.setValue(noteContent, forKeyPath: "noteContent")
        note.setValue(noteDate, forKeyPath: "noteDate")
        note.setValue(noteHasReminder, forKey: "noteHasReminder")
        note.setValue(noteScheduledReminderDate, forKey: "noteScheduledReminderDate")
        
        do {
            try managedContext.save()
            return note as? GameNote
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func updateNote(noteContent: String,noteScheduledReminderDate: Date? = nil,gameNoteId: UUID) -> GameNote? {
        let fetchNote: NSFetchRequest<GameNote> = GameNote.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "id = %@", gameNoteId.uuidString )

        let results = try? managedContext.fetch(fetchNote)
        if let note = results?.first {
            let currentDate = Date.now
            note.noteContent = noteContent
            note.noteDate = currentDate
            note.noteScheduledReminderDate = noteScheduledReminderDate
            
            
            do {
                try managedContext.save()
                return note
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }

        return nil
    }
  

    func deleteNote(id: UUID) -> Bool {
        let fetchNote: NSFetchRequest<GameNote> = GameNote.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "id = %@", String(id.uuidString))

        if let note = try? managedContext.fetch(fetchNote).first {
            managedContext.delete(note)
            do {
                try managedContext.save()
                return true
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return false
            }
        }
        return false
    }
    
    
    
    
}
