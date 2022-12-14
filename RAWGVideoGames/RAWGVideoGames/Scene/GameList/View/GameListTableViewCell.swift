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
    
    private let parentPlatformImageNameMapping: [String:String] = [
        "pc":"laptopcomputer",
        "playstation":"playstation.logo",
        "xbox":"xbox.logo",
        "ios":"apple.logo",
        "mac": "macpro.gen1"
    ]
    
    
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
    
    private let gameRatingsCountIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "bubble.left")
        imageView.tintColor = .label

        return imageView
    }()
    
    private let gameRatingsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let gameRatingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .label

        return imageView
    }()
    
    private let gameRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let gameReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    

    
    // MARK: Configure UI Components
    private func configureConstraints() {
        let gameImageViewSize = contentView.width / 2
        let iconImageViewSize: CGFloat = 16.0
        let platformIconImageViewSize: CGFloat = 22.0
        
        let gameImageViewConstraints = [
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gameImageView.widthAnchor.constraint(equalToConstant: gameImageViewSize),
            gameImageView.heightAnchor.constraint(equalToConstant: gameImageViewSize)
        ]
        
        let gameNameLabelConstraints = [
            gameNameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor),
            gameNameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 20),
            gameNameLabel.widthAnchor.constraint(equalToConstant: contentView.width - gameImageViewSize)
        ]
        
        let gameReleaseDateLabelConstraints = [
            gameReleaseDateLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 5),
            gameReleaseDateLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameReleaseDateLabel.widthAnchor.constraint(equalToConstant: contentView.width - gameImageViewSize)
        ]
      
        let gameRatingsCountIconImageViewConstraints = [
            gameRatingsCountIconImageView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameRatingsCountIconImageView.topAnchor.constraint(equalTo: gameReleaseDateLabel.bottomAnchor,constant: platformIconImageViewSize + 20),
            gameRatingsCountIconImageView.widthAnchor.constraint(equalToConstant: iconImageViewSize),
            gameRatingsCountIconImageView.heightAnchor.constraint(equalToConstant: iconImageViewSize)
        ]
        
        let gameRatingsCountLabelConstraints = [
            gameRatingsCountLabel.topAnchor.constraint(equalTo: gameRatingsCountIconImageView.topAnchor),
            gameRatingsCountLabel.leadingAnchor.constraint(equalTo: gameRatingsCountIconImageView.trailingAnchor, constant: 5),
        ]
        
        let gameRatingImageViewConstraints = [
            gameRatingIconImageView.leadingAnchor.constraint(equalTo: gameRatingsCountLabel.trailingAnchor, constant: 10),
            gameRatingIconImageView.topAnchor.constraint(equalTo: gameRatingsCountLabel.topAnchor),
            gameRatingIconImageView.widthAnchor.constraint(equalToConstant: iconImageViewSize),
            gameRatingIconImageView.heightAnchor.constraint(equalToConstant: iconImageViewSize)
        ]
        
        let gameRatingLabelConstraints = [
            gameRatingLabel.topAnchor.constraint(equalTo: gameRatingIconImageView.topAnchor),
            gameRatingLabel.leadingAnchor.constraint(equalTo: gameRatingIconImageView.trailingAnchor, constant: 5),
        ]
        
        let gameTimeIconImageViewConstraints = [
            gameTimeIconImageView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameTimeIconImageView.topAnchor.constraint(equalTo: gameRatingsCountIconImageView.bottomAnchor, constant: 10),
            gameTimeIconImageView.widthAnchor.constraint(equalToConstant: iconImageViewSize),
            gameTimeIconImageView.heightAnchor.constraint(equalToConstant: iconImageViewSize)
        ]
        
        let gameTimeLabelConstraints = [
            gameTimeLabel.topAnchor.constraint(equalTo: gameTimeIconImageView.topAnchor),
            gameTimeLabel.leadingAnchor.constraint(equalTo: gameTimeIconImageView.trailingAnchor, constant: 5),
        ]
        
        
        let gamePlatformLabelConstraints = [
            gamePlatformLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gamePlatformLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 20),
            gamePlatformLabel.widthAnchor.constraint(equalToConstant: contentView.width)
        ]
        
        
        
        
        NSLayoutConstraint.activate(gameImageViewConstraints)
        NSLayoutConstraint.activate(gameNameLabelConstraints)
        NSLayoutConstraint.activate(gameReleaseDateLabelConstraints)
        NSLayoutConstraint.activate(gameRatingsCountIconImageViewConstraints)
        NSLayoutConstraint.activate(gameRatingsCountLabelConstraints)
        NSLayoutConstraint.activate(gameRatingImageViewConstraints)
        NSLayoutConstraint.activate(gameRatingLabelConstraints)
        NSLayoutConstraint.activate(gameTimeIconImageViewConstraints)
        NSLayoutConstraint.activate(gameTimeLabelConstraints)
        NSLayoutConstraint.activate(gamePlatformLabelConstraints)

   }
    private func configurePlatformImageViews(gamePlatforms: [Platform]) {
        let iconImageViewSize: CGFloat = 22
        var renderedIconImageViewCount = 0
        
        gamePlatforms.forEach {platformInfo in
            guard let imageName = parentPlatformImageNameMapping[platformInfo.platform.slug] else { return }
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(systemName: imageName)
            imageView.tintColor = .label
            
            addSubview(imageView)
            
            imageView.topAnchor.constraint(equalTo: gameReleaseDateLabel.bottomAnchor,constant: 10).isActive = true
            imageView.leadingAnchor.constraint(equalTo: gameReleaseDateLabel.leadingAnchor, constant: iconImageViewSize * CGFloat(renderedIconImageViewCount) + CGFloat(renderedIconImageViewCount) * 5).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: iconImageViewSize).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: iconImageViewSize).isActive = true
            
            renderedIconImageViewCount += 1
            
        }
    }
   
    
    private func configureSubviews() {
        addSubview(gameImageView)
        addSubview(gameNameLabel)
        addSubview(gameReleaseDateLabel)
        addSubview(gameTimeIconImageView)
        addSubview(gameTimeLabel)
        addSubview(gameRatingIconImageView)
        addSubview(gameRatingLabel)
        addSubview(gameRatingsCountIconImageView)
        addSubview(gameRatingsCountLabel)
        addSubview(gamePlatformLabel)

    }
    
    // If there is no image, the "photo" image will be used to provide a consistent structure
    func configureCell(game: GameModel){
        gameImageView.sd_setImage(with: URL(string: game.imageURL ?? ""))
        gameNameLabel.text = game.name
        gameReleaseDateLabel.text = game.releaseDate
        gameTimeLabel.text = String(game.playtime ?? 0)
        gameRatingLabel.text = String(game.rating ?? 0.0)
        gameRatingsCountLabel.text = String(game.ratingsCount ?? 0)
        
        
        configurePlatformImageViews(gamePlatforms: game.parentPlatforms ?? [])
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
