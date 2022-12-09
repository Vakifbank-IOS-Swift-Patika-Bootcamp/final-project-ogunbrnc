//
//  GameDetailViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    var gameId: Int?
    private var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()

    
    // MARK: UI Components
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Game Name"
        return label
    }()
    
    private let gamePlatformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Game platforms"
        return label
    }()
    
    private let gamePlatformContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Game platforms Content,Game platforms Content,"
        return label
    }()
    
    private let gameGenreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Game Genres"
        return label
    }()
    
    private let gameGenreContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Game Genres Content"
        return label
    }()
    
    private let gameReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Release date"
        return label
    }()
    
    private let gameReleaseDateContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Release date Content"
        return label
    }()
    
    private let gameTagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Tags"
        return label
    }()
    
    private let gameTagContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Tags content"
        return label
    }()
    
    private let gameDescriptionContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description.Game description."
        return label
    }()
    
    // MARK: Configure UI Components
   private func configureConstraints() {
       let gameImageViewConstraints = [
            gameImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            gameImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gameImageView.widthAnchor.constraint(equalToConstant: 350),
            gameImageView.heightAnchor.constraint(equalToConstant: 150)
       ]
       let gameNameLabelConstraints = [
            gameNameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor,constant: 20),
            gameNameLabel.centerXAnchor.constraint(equalTo: gameImageView.centerXAnchor)
        ]
       
       let gamePlatformLabelConstraints = [
            gamePlatformLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gamePlatformLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 10)
       ]
       
       let gamePlatformContentLabelConstraints = [
            gamePlatformContentLabel.leadingAnchor.constraint(equalTo: gamePlatformLabel.leadingAnchor),
            gamePlatformContentLabel.topAnchor.constraint(equalTo: gamePlatformLabel.bottomAnchor, constant: 10),
            gamePlatformContentLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -80)
            
       ]
       
       let gameGenreLabelConstraints = [
            gameGenreLabel.leadingAnchor.constraint(equalTo: gamePlatformLabel.trailingAnchor, constant: 20),
            gameGenreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gameGenreLabel.topAnchor.constraint(equalTo: gamePlatformLabel.topAnchor)
        
       ]
       
       let gameGenreContentLabelConstraints = [
            gameGenreContentLabel.leadingAnchor.constraint(equalTo: gameGenreLabel.leadingAnchor),
            gameGenreContentLabel.trailingAnchor.constraint(equalTo: gameGenreLabel.trailingAnchor),
            gameGenreContentLabel.topAnchor.constraint(equalTo: gameGenreLabel.bottomAnchor, constant: 10),
            gameGenreContentLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -80)
        
       ]
       
       let gameReleaseDateLabelConstraints = [
            gameReleaseDateLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gameReleaseDateLabel.topAnchor.constraint(equalTo: gamePlatformContentLabel.bottomAnchor, constant: 10)
       ]
       
       let gameReleaseDateContentLabelConstraints = [
            gameReleaseDateContentLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gameReleaseDateContentLabel.topAnchor.constraint(equalTo: gameReleaseDateLabel.bottomAnchor, constant: 10),
            
       ]
   
       let gameTagsLabelConstraints = [
            gameTagLabel.leadingAnchor.constraint(equalTo: gameGenreLabel.leadingAnchor),
            gameTagLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gameTagLabel.topAnchor.constraint(equalTo: gameReleaseDateLabel.topAnchor)
        
       ]
       
       let gameTagsContentLabelConstraints = [
            gameTagContentLabel.leadingAnchor.constraint(equalTo: gameTagLabel.leadingAnchor),
            gameTagContentLabel.trailingAnchor.constraint(equalTo: gameTagLabel.trailingAnchor),
            gameTagContentLabel.topAnchor.constraint(equalTo: gameTagLabel.bottomAnchor, constant: 10)
        
       ]
       
       let gameDescriptionContentLabelConstraints = [
            gameDescriptionContentLabel.leadingAnchor.constraint(equalTo: gamePlatformLabel.leadingAnchor),
            gameDescriptionContentLabel.trailingAnchor.constraint(equalTo: gameGenreLabel.trailingAnchor),
            gameDescriptionContentLabel.topAnchor.constraint(equalTo: gameTagContentLabel.bottomAnchor, constant: 20)
        
       ]
       
       NSLayoutConstraint.activate(gameImageViewConstraints)
       NSLayoutConstraint.activate(gameNameLabelConstraints)
       NSLayoutConstraint.activate(gamePlatformLabelConstraints)
       NSLayoutConstraint.activate(gamePlatformContentLabelConstraints)
       NSLayoutConstraint.activate(gameGenreLabelConstraints)
       NSLayoutConstraint.activate(gameGenreContentLabelConstraints)
       NSLayoutConstraint.activate(gameReleaseDateLabelConstraints)
       NSLayoutConstraint.activate(gameReleaseDateContentLabelConstraints)
       NSLayoutConstraint.activate(gameTagsLabelConstraints)
       NSLayoutConstraint.activate(gameTagsContentLabelConstraints)
       NSLayoutConstraint.activate(gameDescriptionContentLabelConstraints)

     

   }
    
    private func configureSubviews() {
        view.addSubview(gameImageView)
        view.addSubview(gameNameLabel)
        view.addSubview(gamePlatformLabel)
        view.addSubview(gamePlatformContentLabel)
        view.addSubview(gameGenreLabel)
        view.addSubview(gameGenreContentLabel)
        view.addSubview(gameReleaseDateLabel)
        view.addSubview(gameReleaseDateContentLabel)
        view.addSubview(gameTagLabel)
        view.addSubview(gameTagContentLabel)
        view.addSubview(gameDescriptionContentLabel)
       
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureConstraints()
        
        guard let id = gameId else { return }
        viewModel.delegate = self
        viewModel.fetchGameDetail(id: id)
    }
}
extension GameDetailViewController: GameDetailViewModelDelegate {
    func gameLoaded() {
        gameNameLabel.text = viewModel.getGameName()
        gamePlatformContentLabel.text = viewModel.getGamePlatform()
        gameGenreContentLabel.text = viewModel.getGameGenre()
        gameReleaseDateContentLabel.text = viewModel.getGameReleaseDate()
        gameTagContentLabel.text = viewModel.getGameTag()
        gameDescriptionContentLabel.text = viewModel.getGameDescription()
        guard let url = viewModel.getGameImageURL() else { return }
        gameImageView.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)

    }
}
