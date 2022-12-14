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
    

    
    // MARK: Configure UI Components
       private func configureConstraints() {
           let gameImageViewConstraints = [
                gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
                gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                gameImageView.widthAnchor.constraint(equalToConstant: 175),
                gameImageView.heightAnchor.constraint(equalToConstant: 175)
           ]
           
           let gameNameLabelConstraints = [
                gameNameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor),
                gameNameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 20)
           ]
          
           let gamePlatformLabelConstraints = [
                gamePlatformLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
                gamePlatformLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                gamePlatformLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 20)
           ]
       
           
           NSLayoutConstraint.activate(gameImageViewConstraints)
           NSLayoutConstraint.activate(gameNameLabelConstraints)
           NSLayoutConstraint.activate(gamePlatformLabelConstraints)

         

       }
   
    
    private func configureSubviews() {
        addSubview(gameImageView)
        addSubview(gameNameLabel)
        addSubview(gamePlatformLabel)
            
    }
    
    // If there is no image, the "photo" image will be used to provide a consistent structure
    func configureCell(game: GameModel){
        gameNameLabel.text = game.name
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
