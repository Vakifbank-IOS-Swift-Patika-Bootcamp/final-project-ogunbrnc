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
        label.text = "There are no notes. \n You can add new note using the + button."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    // MARK: Configure Views
    private func configureSubViews() {
        view.addSubview(floatingActionButton)
    }
    
    private func configureTableView() {
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        view.addSubview(noNoteLabel)
        noNoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noNoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureButtons() {
        floatingActionButton.addTarget(self, action: #selector(didTapAddNote), for: .touchUpInside)
    }
    
    // MARK: UIButton Action
    @objc private func didTapAddNote() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNoNoteLabel()
       configureTableView()
       configureSubViews()
       configureConstraints()
       configureButtons()
    }

}

//MARK: TableView Extension
extension GameNoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "dummy"
        return cell
        
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
   
    
}
