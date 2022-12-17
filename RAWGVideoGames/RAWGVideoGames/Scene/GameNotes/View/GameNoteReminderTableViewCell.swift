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
    
    private let gameReminderScheduledTimeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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
        ]
        
        let gameReminderScheduledTimeImageViewConstraints = [
            gameReminderScheduledTimeImageView.trailingAnchor.constraint(equalTo: gameNoteDateLabel.trailingAnchor),
            gameReminderScheduledTimeImageView.topAnchor.constraint(equalTo: gameNoteDateLabel.bottomAnchor, constant: 10),
            gameReminderScheduledTimeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        
        
        NSLayoutConstraint.activate(gameNameLabelConstraints)
        NSLayoutConstraint.activate(gameNoteContentLabelConstraints)
        NSLayoutConstraint.activate(gameNoteDateLabelConstraints)
        NSLayoutConstraint.activate(gameReminderScheduledTimeImageViewConstraints)

    }
    
    private func configureSubviews(){
        addSubview(gameNameLabel)
        addSubview(gameNoteDateLabel)
        addSubview(gameNoteContentLabel)
        addSubview(gameReminderScheduledTimeImageView)
    }
    
    // Season and episode will be used seperated by "." to be more readable.
    func configure(with model: GameNote){
        guard let noteDate = model.noteDate,
              let noteScheduledDate = model.noteScheduledReminderDate else { return }
        
        let currentDate = Date.now
        gameNameLabel.text = model.gameName
        gameNoteDateLabel.text = noteDate.toFormattedString()
        gameNoteContentLabel.text = model.noteContent
        let imageName = currentDate > noteScheduledDate  ? "checkmark.circle" : "clock"
        gameReminderScheduledTimeImageView.image = UIImage(systemName: imageName)
        
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
