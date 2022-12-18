//
//  GameListTableViewCell.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit
import SDWebImage

enum parentPlatformsImage: String {
    case pc
    case playstation
    case xbox
    case ios
    case mac
    
    var imageSystemName: String {
        switch self {
        case .pc:
            return "laptopcomputer"
        case .playstation:
            return "playstation.logo"
        case .xbox:
            return "xbox.logo"
        case .ios:
            return "apple.logo"
        case .mac:
            return "macpro.gen1"
        }
    }
}

final class GameListTableViewCell: UITableViewCell {

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
    
    private let gameReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let gameTimeIconLabelStackView: IconLabelStackView = {
        let iconLabelStackView = IconLabelStackView()
        iconLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        return iconLabelStackView
    }()
    private let gameRatingCountIconLabelStackView: IconLabelStackView = {
        let iconLabelStackView = IconLabelStackView()
        iconLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        return iconLabelStackView
    }()
    
    private let gameRatingAverageIconLabelStackView: IconLabelStackView = {
        let iconLabelStackView = IconLabelStackView()
        iconLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        return iconLabelStackView
    }()


    private let gamePlatformsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    // MARK: Configure UI Components
    private func configureConstraints() {
        let gameImageViewSize = contentView.width / 2 - 40
        
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
        
        let gamePlatformsStackViewConstraints = [
            gamePlatformsStackView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gamePlatformsStackView.topAnchor.constraint(equalTo: gameReleaseDateLabel.bottomAnchor,constant: 10),
            gamePlatformsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        let gameRatingCountIconLabelStackViewConstraints = [
            gameRatingCountIconLabelStackView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameRatingCountIconLabelStackView.topAnchor.constraint(equalTo: gamePlatformsStackView.bottomAnchor,constant: 10),
            gameRatingCountIconLabelStackView.widthAnchor.constraint(equalToConstant: 80),
            gameRatingCountIconLabelStackView.heightAnchor.constraint(equalToConstant: 15)
        ]
        
        let gameRatingAverageIconLabelStackViewConstraints = [
            gameRatingAverageIconLabelStackView.leadingAnchor.constraint(equalTo: gameRatingCountIconLabelStackView.trailingAnchor, constant: 10),
            gameRatingAverageIconLabelStackView.topAnchor.constraint(equalTo: gameRatingCountIconLabelStackView.topAnchor),
            gameRatingAverageIconLabelStackView.widthAnchor.constraint(equalToConstant: 80),
            gameRatingCountIconLabelStackView.heightAnchor.constraint(equalToConstant: 15)
        ]
        
        let gameTimeIconLabelStackViewConstraints = [
            gameTimeIconLabelStackView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameTimeIconLabelStackView.topAnchor.constraint(equalTo: gameRatingCountIconLabelStackView.bottomAnchor, constant: 10),
            gameTimeIconLabelStackView.widthAnchor.constraint(equalToConstant: 80),
            gameTimeIconLabelStackView.heightAnchor.constraint(equalToConstant: 15)
        ]
        
        
        NSLayoutConstraint.activate(gameImageViewConstraints)
        NSLayoutConstraint.activate(gameNameLabelConstraints)
        NSLayoutConstraint.activate(gameReleaseDateLabelConstraints)
        NSLayoutConstraint.activate(gamePlatformsStackViewConstraints)
        NSLayoutConstraint.activate(gameRatingCountIconLabelStackViewConstraints)
        NSLayoutConstraint.activate(gameRatingAverageIconLabelStackViewConstraints)
        NSLayoutConstraint.activate(gameTimeIconLabelStackViewConstraints)

   }
    private func configurePlatformImageViews(gamePlatforms: [Platform]) {
        let iconImageViewSize: CGFloat = 22
        var renderedIconImageViewCount = 0
        
        gamePlatforms.forEach {platformInfo in
            guard let imageName = parentPlatformsImage(rawValue: platformInfo.platform.slug)?.imageSystemName else { return }
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(systemName: imageName)
            imageView.tintColor = .label
            
            gamePlatformsStackView.addArrangedSubview(imageView)
            
            imageView.widthAnchor.constraint(equalToConstant: iconImageViewSize).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: iconImageViewSize).isActive = true
            
            renderedIconImageViewCount += 1
            
        }
    }
   
    
    private func configureSubviews() {
        addSubview(gameImageView)
        addSubview(gameNameLabel)
        addSubview(gameReleaseDateLabel)
        addSubview(gamePlatformsStackView)
        addSubview(gameTimeIconLabelStackView)
        addSubview(gameRatingCountIconLabelStackView)
        addSubview(gameRatingAverageIconLabelStackView)
        

    }
    
    func configureCell(game: GameModel){
        gameImageView.sd_setImage(with: URL(string: game.imageURL ?? ""))
        gameNameLabel.text = game.name
        gameReleaseDateLabel.text = game.releaseDate
        gameTimeIconLabelStackView.configure(imageSystemName: "timer", labelValue: String(game.playtime ?? 0) + "min".localized())
        gameRatingCountIconLabelStackView.configure(imageSystemName: "bubble.left", labelValue: String(game.ratingsCount ?? 0))
        gameRatingAverageIconLabelStackView.configure(imageSystemName: "star", labelValue: String(game.rating ?? 0.0))
        
        
        configurePlatformImageViews(gamePlatforms: game.parentPlatforms ?? [])
    }
    
    override func prepareForReuse() {
        gameImageView.image = nil
        gamePlatformsStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})

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
