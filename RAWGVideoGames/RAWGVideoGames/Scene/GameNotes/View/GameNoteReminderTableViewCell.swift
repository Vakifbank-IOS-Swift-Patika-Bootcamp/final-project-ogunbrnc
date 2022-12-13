//
//  GameNoteReminderTableViewCell.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 13.12.2022.
//

import UIKit

class GameNoteReminderTableViewCell: UITableViewCell {

    static var identifier = "GameNoteReminderTableViewCell"


    // MARK: UI Components
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private let gameNoteDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let gameNoteContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: Configure UI Components
    private func configureConstraints() {
            
        let gameNameLabelConstraints = [
            gameNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            gameNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ]
        
        let gameNoteContentLabelConstraints = [
            gameNoteContentLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameNoteContentLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor,constant: 10)
        
        ]
        
        let gameNoteDateLabelConstraints = [
            gameNoteDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            gameNoteDateLabel.topAnchor.constraint(equalTo: gameNoteContentLabel.bottomAnchor, constant: 10),
            gameNoteDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        
        
        NSLayoutConstraint.activate(gameNameLabelConstraints)
        NSLayoutConstraint.activate(gameNoteContentLabelConstraints)
        NSLayoutConstraint.activate(gameNoteDateLabelConstraints)

    }
    
    private func configureSubviews(){
        addSubview(gameNameLabel)
        addSubview(gameNoteDateLabel)
        addSubview(gameNoteContentLabel)
    }
    
    // Season and episode will be used seperated by "." to be more readable.
    func configure(with model: GameNote){
        gameNameLabel.text = model.gameName
        gameNoteDateLabel.text = dateToString(model.noteDate ?? Date())
        gameNoteContentLabel.text = model.noteContent
        
    }
    
    // dateToString function take date argument and convert to
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: date)
    }
    
    // MARK: Life Cycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureConstraints()
            
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
