//
//  CoreDataManager.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func isFavorite(id gameId: Int) -> Bool {
        let fetchNote: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "id = %@", String(gameId))

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
    
    
    func addToFavorite(id gameId: Int) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        game.setValue(gameId, forKeyPath: "id")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteFromFavorite(id gameId: Int) -> Bool {
        let fetchNote: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "id = %@", String(gameId))

        if let game = try? managedContext.fetch(fetchNote).first {
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
}
