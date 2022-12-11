//
//  GameNoteAddingEditingViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import UIKit

protocol GameNoteAddingEditingViewControllerDelegate: AnyObject {
    func didAddNote(gameNote: GameNote)
    func didUpdateNote(gameNote: GameNote)
}

class GameNoteAddingEditingViewController: UIViewController {

    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var gameNoteTextField: UITextField!
    
    var noteId: UUID?
    weak var delegate: GameNoteAddingEditingViewControllerDelegate?
    private var viewModel: GameNoteAddingEditingViewModelProtocol = GameNoteAddingEditingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.getNote(noteId: noteId)
    }
    
    @IBAction func saveNoteClicked(_ sender: Any) {
        guard let gameName = gameNameTextField.text,
              !gameName.isEmpty,
              let gameNote = gameNoteTextField.text,
              !gameNote.isEmpty else {
            return
        }
        viewModel.saveNote(gameName: gameName, noteContent: gameNote)
    }
}
extension GameNoteAddingEditingViewController: GameNoteAddingEditingViewModelDelegate {
    
    func didAddNote(gameNote: GameNote) {
        delegate?.didAddNote(gameNote: gameNote)
        dismiss(animated: true)
    }
    func didUpdateNote(gameNote: GameNote) {
        delegate?.didUpdateNote(gameNote: gameNote)
        dismiss(animated: true)

    }
    
    func didNoteLoaded(gameNote: GameNote?) {
        gameNoteTextField.text = gameNote?.noteContent
        gameNameTextField.text = gameNote?.gameName
    }

}
