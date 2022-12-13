//
//  GameNoteAddingEditingViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import UIKit


enum GameNoteType {
    case note
    case reminder
}

protocol GameNoteAddingEditingViewControllerDelegate: AnyObject {
    func didAddNote(gameNote: GameNote)
    func didUpdateNote(gameNote: GameNote)
}

class GameNoteAddingEditingViewController: UIViewController {

    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var gameNoteTextField: UITextField!
    @IBOutlet weak var noteTypeSegmentedControl: UISegmentedControl!
    
    private let gameNoteReminderDatePicker: UIDatePicker =  {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        
        
        return datePicker
    }()
    
    var noteId: UUID?
    weak var delegate: GameNoteAddingEditingViewControllerDelegate?
    private var viewModel: GameNoteAddingEditingViewModelProtocol = GameNoteAddingEditingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        
        
        viewModel.delegate = self
        viewModel.getNote(noteId: noteId)
        
    }
    
    private func configureSegmentedControl(){
        noteTypeSegmentedControl.addTarget(self, action: #selector(noteTypeSegmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    
    
    private func configureDatePickerConstraints () {
        gameNoteReminderDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameNoteReminderDatePicker.topAnchor.constraint(equalTo: gameNoteTextField.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc private func noteTypeSegmentedControlValueChanged (_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gameNoteReminderDatePicker.removeFromSuperview()
        } else {
            view.addSubview(gameNoteReminderDatePicker)
            configureDatePickerConstraints()
        }
    }

    @IBAction func saveNoteClicked(_ sender: Any) {
        guard let gameName = gameNameTextField.text,
              !gameName.isEmpty,
              let gameNote = gameNoteTextField.text,
              !gameNote.isEmpty else {
            return
        }
        
        if noteTypeSegmentedControl.selectedSegmentIndex == 0 {
            viewModel.saveNote(gameName: gameName, noteContent: gameNote)
        } else {
            viewModel.saveReminder(gameName: gameName, reminderContent: gameNote, reminderDate: gameNoteReminderDatePicker.date)
        }
        
        
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
