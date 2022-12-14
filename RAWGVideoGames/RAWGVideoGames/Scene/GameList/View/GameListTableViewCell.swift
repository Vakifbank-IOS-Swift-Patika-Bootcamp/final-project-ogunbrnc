//
//  GameListTableViewCell.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit
import SDWebImage

class GameListTableViewCell: UITableViewCell {

    static var identifier = "GameListTableViewCell"
    
    // MARK: UI Components
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let gamePlatformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let gameTimeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "timer")
        imageView.tintColor = .label

        return imageView
    }()
    
    private let gameTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    

    
    // MARK: Configure UI Components
       private func configureConstraints() {
           
           let gameImageViewConstraints = [
                gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
                gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                gameImageView.widthAnchor.constraint(equalToConstant: 175 ),
                gameImageView.heightAnchor.constraint(equalToConstant: 175)
           ]
           
           let gameNameLabelConstraints = [
                gameNameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor),
                gameNameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 20),
                gameNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)

           ]
          
           let gameTimeIconImageViewConstraints = [
                gameTimeIconImageView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
                gameTimeIconImageView.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor,constant: 10),
                gameTimeIconImageView.widthAnchor.constraint(equalToConstant: 16),
                gameTimeIconImageView.heightAnchor.constraint(equalToConstant: 16)
           ]
           
           let gameTimeLabelConstraints = [
                gameTimeLabel.topAnchor.constraint(equalTo: gameTimeIconImageView.topAnchor),
                gameTimeLabel.leadingAnchor.constraint(equalTo: gameTimeIconImageView.trailingAnchor, constant: 5),
           ]
          
           
           let gamePlatformLabelConstraints = [
                gamePlatformLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
                gamePlatformLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                gamePlatformLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 20)
           ]
       
           
           NSLayoutConstraint.activate(gameImageViewConstraints)
           NSLayoutConstraint.activate(gameNameLabelConstraints)
           NSLayoutConstraint.activate(gamePlatformLabelConstraints)
           NSLayoutConstraint.activate(gameTimeIconImageViewConstraints)
           NSLayoutConstraint.activate(gameTimeLabelConstraints)

         

       }
   
    
    private func configureSubviews() {
        addSubview(gameImageView)
        addSubview(gameNameLabel)
        addSubview(gamePlatformLabel)
        addSubview(gameTimeIconImageView)
        addSubview(gameTimeLabel)
    }
    
    // If there is no image, the "photo" image will be used to provide a consistent structure
    func configureCell(game: GameModel){
        gameNameLabel.text = game.name
        gameTimeLabel.text = String(game.playtime ?? 0)
        gameImageView.sd_setImage(with: URL(string: game.imageURL ?? ""))
        
        
        let platforms = game.platforms?.map { $0.platform.name }.joined(separator: ",") ?? ""
        gamePlatformLabel.text = "Platforms:".localized() + platforms
    }
    
    override func prepareForReuse() {
        gameImageView.image = nil

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
