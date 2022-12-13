//
//  GameNoteListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 11.12.2022.
//

import UIKit

class GameNoteListViewController: UIViewController {
    
    //MARK: UI Components
    @IBOutlet private weak var notesTableView: UITableView!
    @IBOutlet private weak var notesRemindersSegmentedControl: UISegmentedControl!
    
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
        label.text = "There are no notes. \n You can add new note using the + button.".localized()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private var viewModel: GameNoteListViewModelProtocol = GameNoteListViewModel()

    
    // MARK: Configure Views
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
        if viewModel.getGameNotesCount() == 0 {
            view.addSubview(noNoteLabel)
            noNoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noNoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    private func configureButtons() {
        floatingActionButton.addTarget(self, action: #selector(didTapAddNote), for: .touchUpInside)
    }
    
    
    private func configureSegmentedControl() {
        notesRemindersSegmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }
    
    @objc func handleSegmentChange() {
        notesTableView.reloadData()
    }
    
    // MARK: UIButton Action
    @objc private func didTapAddNote() {
        guard let noteAddingEditingViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameNoteAddingEditingViewController") as? GameNoteAddingEditingViewController else {
            fatalError("View Controller not found")
        }
        noteAddingEditingViewController.delegate = self
        navigationController?.present(noteAddingEditingViewController, animated: true)
    }

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

extension GameNoteListViewController: GameNoteListViewModelDelegate {
    func gameNotesLoaded() {
        notesTableView.reloadData()
    }
}

//MARK: TableView Extension
extension GameNoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGameNotesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameNoteListTableViewCell.identifier,for: indexPath) as? GameNoteListTableViewCell, let note = viewModel.getGameNote(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        let note = viewModel.getGameNote(at: indexPath.row)
        guard let noteAddingOrEditingViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameNoteAddingEditingViewController") as? GameNoteAddingEditingViewController else {
                   fatalError("View Controller not found")
               }
        noteAddingOrEditingViewController.delegate = self
        noteAddingOrEditingViewController.noteId = note?.id
        navigationController?.present(noteAddingOrEditingViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteId = viewModel.getGameNoteId(at: indexPath.row)
            viewModel.delete(id: noteId ?? UUID())
            
            // if there is no note left when the note is deleted
            if viewModel.getGameNotesCount() == 0  {
                configureNoNoteLabel()
            }
        }
    }
}

extension GameNoteListViewController: GameNoteAddingEditingViewControllerDelegate {
    func didAddNote(gameNote: GameNote) {
        print(viewModel.getGameNotesCount())
        if viewModel.getGameNotesCount() == 0 {
            noNoteLabel.removeFromSuperview()
        }
        viewModel.add(note: gameNote)
    }
    
    func didUpdateNote(gameNote: GameNote) {
        viewModel.update(note: gameNote)
    }
}
