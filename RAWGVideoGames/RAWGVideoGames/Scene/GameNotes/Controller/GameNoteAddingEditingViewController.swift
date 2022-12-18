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
    func didAddReminder(gameNote: GameNote)
    func didUpdateReminder(gameNote: GameNote)
}

final class GameNoteAddingEditingViewController: BaseViewController {

    //MARK: IBOutlets
    @IBOutlet private weak var gameNameTextField: UITextField!
    @IBOutlet private weak var gameNoteTextView: UITextView!
    @IBOutlet private weak var noteTypeSegmentedControl: UISegmentedControl!
    
    //MARK: UI Components
    private let gameNoteReminderDatePicker: UIDatePicker =  {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    //MARK: Variable Declarations
    var noteId: UUID?
    weak var delegate: GameNoteAddingEditingViewControllerDelegate?
    private var viewModel: GameNoteAddingEditingViewModelProtocol = GameNoteAddingEditingViewModel()

    //MARK: Configure UI Components
    private func configureSegmentedControl(){
        noteTypeSegmentedControl.addTarget(self, action: #selector(noteTypeSegmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func configureDatePickerConstraints () {
        gameNoteReminderDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameNoteReminderDatePicker.topAnchor.constraint(equalTo: gameNoteTextView.bottomAnchor, constant: 20).isActive = true
    }
    
    //MARK: Selector Functions
    @objc private func noteTypeSegmentedControlValueChanged (_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gameNoteReminderDatePicker.removeFromSuperview()
        } else {
            view.addSubview(gameNoteReminderDatePicker)
            configureDatePickerConstraints()
        }
    }

    //MARK: IBActions
    @IBAction func saveNoteClicked(_ sender: Any) {
        guard let gameName = gameNameTextField.text,
              !gameName.isEmpty,
              let gameNote = gameNoteTextView.text,
              !gameNote.isEmpty else {
            showAlert(title: "Not Saved".localized(), message: "All fields must be filled.".localized())
            return
        }
        
        if noteTypeSegmentedControl.selectedSegmentIndex == 0 {
            if viewModel.getNoteContent() == gameNote {
                showAlert(title: "Not Saved".localized(), message: "Note content should be updated".localized())
                return
            }
            viewModel.saveNote(gameName: gameName, noteContent: gameNote)
        } else {
            viewModel.saveReminder(gameName: gameName, reminderContent: gameNote, reminderDate: gameNoteReminderDatePicker.date)
        }
    }
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.getNote(noteId: noteId)
        configureSegmentedControl()
        
    }
}
extension GameNoteAddingEditingViewController: GameNoteAddingEditingViewModelDelegate {
    func didNoteLoaded(gameNote: GameNote?, pageViewMode: PageViewMode) {
        if pageViewMode == .edit {
            guard let gameNote = gameNote else { return }
            
            gameNoteTextView.text = gameNote.noteContent
            gameNameTextField.text = gameNote.gameName
            if gameNote.noteHasReminder {
                guard let scheduledReminderDate = gameNote.noteScheduledReminderDate else { return }
                noteTypeSegmentedControl.selectedSegmentIndex = 1
                gameNoteReminderDatePicker.date = scheduledReminderDate
                view.addSubview(gameNoteReminderDatePicker)
                configureDatePickerConstraints()
            }
            
            noteTypeSegmentedControl.isUserInteractionEnabled = false
        }
    }
    
    func didAddReminder(gameNote: GameNote) {
        delegate?.didAddReminder(gameNote: gameNote)
        dismiss(animated: true)
    }
    
    func didUpdateReminder(gameNote: GameNote) {
        delegate?.didUpdateReminder(gameNote: gameNote)
        dismiss(animated: true)
    }
    
    func didAddNote(gameNote: GameNote) {
        delegate?.didAddNote(gameNote: gameNote)
        dismiss(animated: true)
    }
    func didUpdateNote(gameNote: GameNote) {
        delegate?.didUpdateNote(gameNote: gameNote)
        dismiss(animated: true)
    }
    
    func didAuthErrorOccur(error: String) {
        let alertController = UIAlertController(title: "Enable Notifications", message: error.localized(), preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: "Settings", style: .default)
        { (_) in
            guard let setttingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if(UIApplication.shared.canOpenURL(setttingsURL)) {
                UIApplication.shared.open(setttingsURL) { (_) in}
            }
        }
        alertController.addAction(goToSettings)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
        self.present(alertController, animated: true)
    }

}
