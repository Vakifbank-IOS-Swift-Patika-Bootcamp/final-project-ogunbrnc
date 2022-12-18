//
//  GameNoteListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import UIKit

final class GameNoteListViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet private weak var notesTableView: UITableView!
    @IBOutlet private weak var notesRemindersSegmentedControl: UISegmentedControl!
    
    //MARK: UI Components
    private let floatingActionButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingButton.tintColor = .systemBackground

        floatingButton.backgroundColor = .label
        floatingButton.layer.cornerRadius = 25
        return floatingButton
    }()
    
    private let noNoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    //MARK: Variable Declarations
    private var viewModel: GameNoteListViewModelProtocol = GameNoteListViewModel()

    
    // MARK: Configure UI Components
    private func configureSubViews() {
        view.addSubview(floatingActionButton)
    }
    
    private func configureTableView() {
        notesTableView.register(GameNoteListTableViewCell.self, forCellReuseIdentifier: GameNoteListTableViewCell.identifier)
        notesTableView.register(GameNoteReminderTableViewCell.self, forCellReuseIdentifier: GameNoteReminderTableViewCell.identifier)
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func configureConstraints() {
        let floatingActionButtonConstraints = [
            floatingActionButton.widthAnchor.constraint(equalToConstant: 50),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 50),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            floatingActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(floatingActionButtonConstraints)
    }
        
    private func configureNoNoteLabel(){
        let noteCount: Int
        let noNoteLabelContent: String
        if notesRemindersSegmentedControl.selectedSegmentIndex == 0 {
            noteCount = viewModel.getGameNotesCount()
            noNoteLabelContent = "There are no notes. \n You can add new note using the + button.".localized()
        }
        else {
            noteCount = viewModel.getGameNotesHasReminderCount()
            noNoteLabelContent = "There are no reminders. \n You can add new reminders using the + button.".localized()
        }
        
        if noteCount == 0 {
            noNoteLabel.text = noNoteLabelContent
            view.addSubview(noNoteLabel)
            noNoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            noNoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            noNoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        else {
            noNoteLabel.removeFromSuperview()
        }
    }
    
    
    private func configureButtons() {
        floatingActionButton.addTarget(self, action: #selector(didTapAddNote), for: .touchUpInside)
    }
    
    
    private func configureSegmentedControl() {
        notesRemindersSegmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }
    
    //MARK: Selector Functions
    @objc func handleSegmentChange() {
        configureNoNoteLabel()
        notesTableView.reloadData()
    }
    
    @objc private func didTapAddNote() {
        guard let noteAddingEditingViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameNoteAddingEditingViewController") as? GameNoteAddingEditingViewController else {
            fatalError("View Controller not found")
        }
        noteAddingEditingViewController.delegate = self
        navigationController?.present(noteAddingEditingViewController, animated: true)
    }

    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchGameNotes()

        configureNoNoteLabel()
        configureTableView()
        configureSubViews()
        configureConstraints()
        configureButtons()
        configureSegmentedControl()
    }

}

// MARK: GameNoteListViewModelDelegate Extension
extension GameNoteListViewController: GameNoteListViewModelDelegate {
    func gameNotesLoaded() {
        notesTableView.reloadData()
    }
}

//MARK: TableView Delegate, DataSource Extension
extension GameNoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notesRemindersSegmentedControl.selectedSegmentIndex == 0 {
            return viewModel.getGameNotesCount()
            
        } else {
            return viewModel.getGameNotesHasReminderCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notesRemindersSegmentedControl.selectedSegmentIndex == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GameNoteListTableViewCell.identifier,for: indexPath) as? GameNoteListTableViewCell,
                  let note = viewModel.getGameNote(at: indexPath.row) else {
                return UITableViewCell()
            }
            cell.configure(with: note)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GameNoteReminderTableViewCell.identifier,for: indexPath) as? GameNoteReminderTableViewCell,
                let note = viewModel.getGameNoteHasReminder(at: indexPath.row) else {
                return UITableViewCell()
            }
            cell.configure(with: note)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note: GameNote?
        tableView.deselectRow(at: indexPath, animated: true)
        
        if notesRemindersSegmentedControl.selectedSegmentIndex == 0 {
            note = viewModel.getGameNote(at: indexPath.row)
        } else {
            note = viewModel.getGameNoteHasReminder(at: indexPath.row)
            if !viewModel.isEditable(note: note!){
                showAlert(title: "Not Editable".localized(), message: "Out of date reminder cannot be edited".localized())
                return
            }
        }
        
        guard let noteAddingOrEditingViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameNoteAddingEditingViewController") as? GameNoteAddingEditingViewController else {
                   fatalError("View Controller not found")
           }
        noteAddingOrEditingViewController.delegate = self
        noteAddingOrEditingViewController.noteId = note?.id
        
        navigationController?.present(noteAddingOrEditingViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let noteId: UUID?
        let noteCount: Int
        if editingStyle == .delete {
            if notesRemindersSegmentedControl.selectedSegmentIndex == 0 {
                noteId = viewModel.getGameNoteId(at: indexPath.row)
                viewModel.delete(id: noteId ?? UUID())
                noteCount = viewModel.getGameNotesCount()
                
            } else {
                noteId = viewModel.getGameNoteHasReminderId(at: indexPath.row)
                viewModel.deleteReminder(id: noteId ?? UUID())
                noteCount = viewModel.getGameNotesHasReminderCount()
            }
            
            // if there is no note left when the note is deleted
            if noteCount == 0  {
                configureNoNoteLabel()
            }
        }
    }
}

//MARK: GameNoteAddingEditingViewControllerDelegate Extension
extension GameNoteListViewController: GameNoteAddingEditingViewControllerDelegate {
    func didAddReminder(gameNote: GameNote) {
        viewModel.add(reminder: gameNote)
        configureNoNoteLabel()

    }
    
    func didUpdateReminder(gameNote: GameNote) {
        let _ = viewModel.update(reminder: gameNote)
    }
    
    func didAddNote(gameNote: GameNote) {
        viewModel.add(note: gameNote)
        configureNoNoteLabel()

    }
    
    func didUpdateNote(gameNote: GameNote) {
        let _ = viewModel.update(note: gameNote)
    }
}
