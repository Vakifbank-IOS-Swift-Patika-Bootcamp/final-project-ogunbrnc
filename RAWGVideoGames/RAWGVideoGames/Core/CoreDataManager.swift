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
    
    
    

}
