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
    func getGameNote(at index: Int) -> GameNote?
    func getGameNoteId(at index: Int) -> Int?
}

protocol GameNoteListViewModelDelegate: AnyObject {
    func gameNotesLoaded()
}

final class GameNoteListViewModel: GameNoteListViewModelProtocol {
    
    weak var delegate: GameNoteListViewModelDelegate?
    private var gameNotes: [GameNote]?
    
    func fetchGameNotes() {
        gameNotes = CoreDataManager.shared.getNotes()
        delegate?.gameNotesLoaded()
    }
    
    func getGameNotesCount() -> Int {
        gameNotes?.count ?? 0
    }
    
    func getGameNote(at index: Int) -> GameNote? {
        gameNotes?[index]
    }
    
    func getGameNoteId(at index: Int) -> Int? {
        Int(gameNotes![index].gameId)

    }
    
}
